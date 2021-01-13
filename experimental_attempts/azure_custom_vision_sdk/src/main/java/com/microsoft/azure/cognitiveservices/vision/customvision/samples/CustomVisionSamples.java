/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 */

//Edited by University of Debrecen
package com.microsoft.azure.cognitiveservices.vision.customvision.samples;

import java.io.*;
import java.util.*;

import com.google.common.io.ByteStreams;

import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Classifier;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Domain;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.DomainType;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.ImageFileCreateBatch;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.ImageFileCreateEntry;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Project;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Region;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.CustomVisionTrainingClient;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.Trainings;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.CustomVisionTrainingManager;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Tag;

public class CustomVisionSamples {

    private static String Input_coord = null;
    private static String Frames_path = null;

    public static void run(CustomVisionTrainingClient trainer) {
        try {
            //Object detection project, upload images
            ObjectDetection(trainer);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    public static void ObjectDetection(CustomVisionTrainingClient trainClient)
    {
        try {
            // Mapping of filenames to their respective regions in the image. The coordinates are specified
            // as left, top, width, height in normalized coordinates. I.e. (left is left in pixels / width in pixels)

            // This is a hardcoded mapping of the files we'll upload along with the bounding box of the object in the
            // image. The bounding box is specified as left, top, width, height in normalized coordinates.
            //  Normalized Left = Left / Width (in Pixels)
            //  Normalized Top = Top / Height (in Pixels)
            //  Normalized Bounding Box Width = (Right - Left) / Width (in Pixels)
            //  Normalized Bounding Box Height = (Bottom - Top) / Height (in Pixels)

            //Not used. This can be used to assign coordinates to an image
            System.out.println("Object Detection uploading");
            Trainings trainer = trainClient.trainings();

            //Find the object detection domain to set the project type
            Domain objectDetectionDomain = null;
            List<Domain> domains = trainer.getDomains();
            for (final Domain domain : domains) {
                if (domain.type() == DomainType.OBJECT_DETECTION) {
                    objectDetectionDomain = domain;
                    break;
                }
            }
            if (objectDetectionDomain == null) {
                System.out.println("Unexpected result; no objects were detected.");
                return;
            }
            //Create an object detection project
            System.out.println("Creating project...");
            Project project = trainer.createProject()
                    .withName("Wildhorse_AI")
                    .withDescription("Wildhorse_AI")
                    .withDomainId(objectDetectionDomain.id())
                    .withClassificationType(Classifier.MULTILABEL.toString())
                    .execute();
            //Create a tag
            Tag horseTag = trainer.createTag()
                    .withProjectId(project.id())
                    .withName("horse")
                    .execute();
            //Necessary step for further use (Print tagID)
            System.out.println("Tag ID: " + horseTag.id());
            //Start to add pictures from folders
            System.out.println("Adding images...");
            File folder = new File(Frames_path);
            File[] listOfFiles = folder.listFiles();
            for (int i = 0; i < listOfFiles.length; i++) {
                String fileName = listOfFiles[i].getName();
                byte[] contents = GetImage(folder.toString(), fileName);
                AddImageToProject(trainer, project, fileName, contents, horseTag.id());
                Thread.sleep(1500);
            }
            System.out.println("Uploading successful");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    private static void AddImageToProject(Trainings trainer, Project project, String fileName, byte[] contents, UUID tag) throws IOException {
        System.out.println("Adding image: " + fileName);
        ImageFileCreateEntry file = new ImageFileCreateEntry()
                .withName(fileName)
                .withContents(contents);

        ImageFileCreateBatch batch = new ImageFileCreateBatch()
                .withImages(Collections.singletonList(file));
        //If Optional region is specified, tack it on and place the tag there, otherwise add it to the batch.
        //Initalize varaibles
        int tempName = 0;
        BufferedReader br = null;
        //Read the proper coordinates txt file
        br = new BufferedReader(new FileReader(Input_coord));
        tempName = Integer.parseInt(fileName.substring(fileName.length()-8,fileName.length()-4));
        //Create resized image
        double x_size = (double)3840*1.5625;
        double y_size = (double)2160*1.5625;
        //Create box size -- Microsoft minimum box size is 50 x 50
        double box_x=(double)50/x_size;
        double box_y=(double)50/y_size;
        //Declare auxiliary variables
        String temp_row;
        //Create a list with coordinates
        List<Region> list = new ArrayList<>();
        int test_counter = 0;
        //Read coordinates from file
        while ((temp_row = br.readLine()) != null) {
            //Extract data from each row
            String[] val = temp_row.split(",");
            int frame_num = Integer.parseInt(val[0]);
            //Avoid unnecessary runs
            if ( tempName != frame_num ){
                if (test_counter == 0) {
                    continue;
                } else {
                    break;
                }
            }
            //Coordinate recalculation
            double x = ((Double.parseDouble(val[1])-16)*1.5625)/x_size;
            double y = ((Double.parseDouble(val[2])-16)*1.5625)/y_size;
            //Blender coordinate recalculation
            //double x = ((Double.parseDouble(val[1])-16)*1.5625)/x_size;
            //double y = ((2160-Double.parseDouble(val[2])-16)*1.5625)/y_size;
            //Define a region which will contain each tag position in every iteration
            Region region = new Region()
                    .withTagId(tag)
                    .withLeft(x)
                    .withTop(y)
                    .withWidth(box_x)
                    .withHeight(box_y);
            //Append region to region list
            list.add(region);
            test_counter++;
            //Does not let to append more than 200 regions (Microsoft limitation)
            if (test_counter > 200){
                break;
            }
        }
        br.close();
        file = file.withRegions(list);
        //Upload file with coordinates
        trainer.createImagesFromFiles(project.id(), batch);
    }
    //Create a byteStream
    private static byte[] GetImage(String folder, String fileName)
    {
        try {
            return ByteStreams.toByteArray(CustomVisionSamples.class.getResourceAsStream(folder + "/" + fileName));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    //Main
    public static void main(String[] args) {
        //Simple argument check
        if (args.length != 1){
            if (args.length > 1)
                System.err.println("Too much arguments!");
            else
                System.err.println("Not enough arguments!");
            System.exit(0);
        }

        try {
            // Authenticate stuff
            String CustomVisionTrainingClientKey = null;
            String Endpoint = null;
            // Path
            BufferedReader br = new BufferedReader(new FileReader(args[0]));
            String arguments;
            while ((arguments = br.readLine()) != null) {
                String []parts = arguments.split("=");
                switch(parts[0]){
                    case "TrainingClientKey":
                        CustomVisionTrainingClientKey=parts[1];
                        break;
                    case "Endpoint":
                        Endpoint=parts[1];
                        break;
                    case "Input_coord":
                        Input_coord=parts[1];
                        break;
                    case "Frames_path":
                        Frames_path=parts[1];
                        break;
                }
            }
            System.out.println("Details: \n\tTraining Client Key:\t" + CustomVisionTrainingClientKey + "\n\tEndpoint:\t\t\t\t" + Endpoint + "\n\tInput coordinate:\t\t" + Input_coord +"\n\tFrames Path:\t\t\t" + Frames_path);
            //Create the proper request
            CustomVisionTrainingClient trainClient = CustomVisionTrainingManager.authenticate("https://{Endpoint}/customvision/v3.0/training/", CustomVisionTrainingClientKey).withEndpoint(Endpoint);
            //Start the process
            run(trainClient);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }
}