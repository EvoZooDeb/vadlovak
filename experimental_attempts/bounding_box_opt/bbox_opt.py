import csv
import math
import sys
import cv2
import numpy as np

def get_IDs(input):
    IDs_list = []
    with open(input, 'r+') as IDs:
        line = IDs.readline()
        while line:
            temp_array = line.split(',')
            if int(temp_array[0]) != 1:
                break
            else:
                IDs_list.append(temp_array[1])
            line = IDs.readline()
        IDs.close()
    return IDs_list

def create_separate_IDs(IDs_list,input):
    ID_indi_list = []
    for i in range(0,len(IDs_list)):
        ID_indi_list.clear()
        with open(input, 'r+') as IDs:
            line = IDs.readline()
            while line:
                temp_array = line.split(',')
                if IDs_list[i] == temp_array[1]:
                    ID_indi_list.append(line)
                line = IDs.readline()
            output_path="".join((output2, IDs_list[i],".csv"))
            for j in range(0,len(ID_indi_list)):
                with open(output_path, 'a') as append_to_file: 
                    original_stdout = sys.stdout
                    sys.stdout = append_to_file                                                          
                    print(ID_indi_list[j], end = '')
                    sys.stdout = original_stdout
                append_to_file.close()     
        IDs.close()

def get_xy(raw_data):
    temp_array = raw_data.split(',')
    x = float(temp_array[2])
    y = 2160-float(temp_array[3])
    return x,y 

def direction_vector(input,output):
    with open(input, 'r+') as csvfile:
        line = csvfile.readline()
        while line:
        # A point row
            p1_raw = line
        # Save current position
            pos = csvfile.tell()      
        # B point row
            for i in range(2):
                p2_raw = csvfile.readline()
            
        # A point
            p1x,p1y = get_xy(p1_raw)
            if (len(p2_raw) == 0):
                break
            else:
        # B points
                p2x,p2y = get_xy(p2_raw)   
            
            d_x,d_y = p2x-p1x,p2y-p1y
            length = math.sqrt(d_x**2+d_y**2)
            b_x=(d_x/length*pix_length)
            b_y=(d_y/length*pix_length)
            
            right_top_x = b_x+d_y/length*pix_height
            right_top_y = b_y-d_x/length*pix_height
            
            left_top_x = b_x-d_y/length*pix_height
            left_top_y = b_y+d_x/length*pix_height
            
            left_bottom_x = right_top_x * -1
            left_bottom_y = right_top_y * -1
            
            right_bottom_x = left_top_x * -1
            right_bottom_y = left_top_y * -1
            
            # Corrected to the coordinate (clockwise direction)
            right_bottom_x+=p1x
            right_bottom_y+=p1y

            left_bottom_x+=p1x
            left_bottom_y+=p1y

            left_top_x+=p1x
            left_top_y+=p1y

            right_top_x+=p1x
            right_top_y+=p1y
            
            temp_frame = p1_raw.split(',')[0]
            with open(output, 'a') as append_to_file: 
                original_stdout = sys.stdout
                sys.stdout = append_to_file                                                          
                print(temp_frame,right_bottom_x,right_bottom_y,left_bottom_x,left_bottom_y,left_top_x,left_top_y,right_top_x,right_top_y, sep=',')
                sys.stdout = original_stdout
            append_to_file.close()
            csvfile.seek(pos)
            line = csvfile.readline()
        csvfile.close()
        
        
def angle_calc(input,output):
    with open(input, 'r+') as csvfile:
        line = csvfile.readline()
        while line:
        # A point row
            p1_raw = line
        # Save current position
            pos = csvfile.tell()      
        # C point row
            for i in range(5):
                p3_raw = csvfile.readline()
        # B point row
            for i in range(5):
                p2_raw = csvfile.readline()
            
        # A point
            p1x,p1y = get_xy(p1_raw)
            if (len(p3_raw) == 0 or len(p2_raw) == 0):
                break
            else:
        # B & C points
                p2x,p2y = get_xy(p2_raw)   
                p3x,p3y = get_xy(p3_raw)
            
        # Sides (https://www.mathsisfun.com/algebra/distance-2-points.html)
            a = math.sqrt(((p2x-p3x)**2)+((p2y-p3y)**2))   # BC distance (B-C)
            b = math.sqrt(((p3x-p1x)**2)+((p3y-p1y)**2))   # CA distance (C-A)
            c = math.sqrt(((p2x-p1x)**2)+((p2y-p1y)**2))   # BA distance (B-A)
        # Law of Cosines (https://www.mathsisfun.com/algebra/trig-cosine-law.html)
            # Divide by zero
            if (-2*a*b) == 0:
                inside_angle = "ign"
                outside_angle = "ign"
            else:
                result = ((c**2)-((a**2)+(b**2)))/(-2*a*b)
                if result < 1 and result > -1:
                    inside_angle = math.degrees(math.acos(((c**2)-((a**2)+(b**2)))/(-2*a*b))) # gamma (middle point from the 3 processed row)
                    
                    outside_angle = 180 - inside_angle
            # Right angle [acos(1)]
                else:
                    inside_angle = 90
                    outside_angle = 90
            
            temp_array = p3_raw.split(',')
            with open(output, 'a') as append_to_file: 
                original_stdout = sys.stdout
                sys.stdout = append_to_file                                                          
                print(temp_array[0],temp_array[1],p3x,p3y,outside_angle, sep=',')
                sys.stdout = original_stdout
            append_to_file.close()
            csvfile.seek(pos)
            line = csvfile.readline()
        csvfile.close()
    
def valid_calc(input,output,threshold):
    with open(input, 'r+') as csvfile:
        line = csvfile.readline()
        while line:
            first = float(line.split(',')[4])
        # Save current position    
            pos = csvfile.tell()
            second = float(csvfile.readline().split(',')[4])
            third = float(csvfile.readline().split(',')[4])
            
            valid = threshold_test(first,second,threshold)
            valid+=threshold_test(first,third,threshold)

            break
            csvfile.seek(pos)
            line = csvfile.readline()
        csvfile.close()
        
def calculate_fx(x1,y1,x2,y2,angle):
    print(new_x,new_y)
    m = (y1-y2)/(x1-x2)   # Slope
    if y1 > -1:
        right_side = (m*-x1)+y1
    else:
        right_side = (m*-x1)-y1

    return m, right_side

def calc_points(x,y,angle):
  # Calculate length of each side  
    c = pix_length
    a = math.sin(math.radians(angle))*c   # y
    b = math.cos(math.radians(angle))*c   # x
    print("x: ",b,", y: ",a,"atlo: ",c)
  # Save these points as mirror point
    mid_x,mid_y = b,a 
  # Simple pythagoras  
    a = pix_length
    b = pix_height
    c = math.sqrt((a**2) + (b**2))
  # Using 'Law of Cosines' solve for angle (https://www.mathsisfun.com/algebra/trig-cosine-law.html)  
    temp_angle = (a**2+c**2-b**2)/(2*a*c)
    temp_angle = math.acos(temp_angle)
    temp_angle = math.degrees(temp_angle)
    print("temp_angle: ", temp_angle)
  # Calculate corrected angle to solve for a perpendicular point  
    temp_angle = angle - temp_angle 
    right_bottom_x = math.cos(math.radians(temp_angle))*c
    right_bottom_y = math.sin(math.radians(temp_angle))*c
    print("#################")
    print(right_bottom_x)
    print(right_bottom_y)
# Mirror across the previously calculated point (right_bottom_x,right_bottom_y)
  # Calculate for x (equation m = (x1+x2)/2)
    right_top_x = 2 * mid_x - right_bottom_x
  # Calculate for y (equation m = (y1+y2)/2)
    right_top_y = 2 * mid_y - right_bottom_y
    print("D: ", right_top_x,right_top_y)
  # Mirroring across origo
    left_top_x, left_top_y = (right_bottom_x * -1), (right_bottom_y * -1)
    
    print("E: ",left_top_x, left_top_y)
    left_bottom_x, left_bottom_y = (right_top_x * -1), (right_top_y * -1)   
    print("F: ",left_bottom_x, left_bottom_y)
    
  # Corrected to the coordinate (clockwise direction)
    right_bottom_x+=x
    right_bottom_y+=y
    
    left_bottom_x+=x
    left_bottom_y+=y
    
    left_top_x+=x
    left_top_y+=y
    
    right_top_x+=x
    right_top_y+=y
    
    return right_bottom_x, right_bottom_y,left_bottom_x,left_bottom_y,left_top_x,left_top_y,right_top_x,right_top_y
   
    
def draw_points(input):
    with open(input, 'r+') as csvfile:
        line = csvfile.readline()
        frame = float(line.split(',')[0])
        x,y = float(line.split(',')[1]),float(line.split(',')[2])
        
        x1,y1,x2,y2,x3,y3,x4,y4 = float(line.split(',')[3]),float(line.split(',')[4]),float(line.split(',')[5]),float(line.split(',')[6]),float(line.split(',')[7]),float(line.split(',')[8]),float(line.split(',')[9]),float(line.split(',')[10])
        
        image = cv2.imread('/home/wildhorse_project/test_pic.png')
        image = cv2.circle(image, (int(x),int(y)), radius=0, color=(255, 0, 0), thickness=3)
        image = cv2.circle(image, (int(x1),int(y1)), radius=0, color=(0, 0, 255), thickness=3)
        image = cv2.circle(image, (int(x2),int(y2)), radius=0, color=(0, 0, 255), thickness=3)
        image = cv2.circle(image, (int(x3),int(y3)), radius=0, color=(0, 0, 255), thickness=3)
        image = cv2.circle(image, (int(x4),int(y4)), radius=0, color=(0, 0, 255), thickness=3)

        cv2.imwrite("/home/wildhorse_project/test_pic_1.png",image)
        cv2.waitKey(0)
        cv2.destroyAllWindows
        
        csvfile.close()

def get_frame_info(input,output_dir):
    with open(input, 'r+') as coord:
        line = coord.readline()
        init_frame = line.split(',')[0]
        while line:
            if init_frame == line.split(',')[0]:
                tmp_str = "_".join((init_frame, 'frame'))
                newstr = "".join((output_dir, tmp_str))
                with open(newstr, 'a') as append_to_file: 
                    original_stdout = sys.stdout
                    sys.stdout = append_to_file                                                          
                    print(temp_array[0],temp_array[1],p3x,p3y,outside_angle, sep=' ')
                    sys.stdout = original_stdout
                append_to_file.close()
        
        coord.close()
        
def create_csv(input,actual_frame,output_dir):
    with open(input, 'r+') as coord:
        line = coord.readline()
        o_file_name = "".join(("_".join(("V180824_2_12fps_4k",str(actual_frame).zfill(4))),".txt"))
        while line:
            if line.split(',')[0] == str(actual_frame):
                new_str = "".join((output_dir,o_file_name))
                x1,y1 = int(float(line.split(',')[1])),int(float(line.split(',')[2]))
                x2,y2 = int(float(line.split(',')[3])),int(float(line.split(',')[4]))
                x3,y3 = int(float(line.split(',')[5])),int(float(line.split(',')[6]))
                x4,y4 = int(float(line.split(',')[7])),int(float(line.split(',')[8]))
                with open(new_str, 'a') as append_to_file: 
                    original_stdout = sys.stdout
                    sys.stdout = append_to_file                                                          
                    print(x1,y1,x2,y2,x3,y3,x4,y4,"horse","0", sep=' ')
                    sys.stdout = original_stdout
                append_to_file.close()
                break
            line = coord.readline()
        coord.close()
# Necessary parameters    
input = '/home/wildhorse_project/horse_coordinates/horse_coordinates/180824/horse_coordinatesID.txt'
output2 = '/home/wildhorse_project/horse_coordinates/horse_coordinates/180824/separate_IDs/'
max_frame = 4149
threshold = 30
pix_length = 32 # Length of horse
pix_height = 16 # Height of horse

pix_height/=2
pix_length/=2

#input_angle_path='/home/wildhorse_project/horse_coordinates/horse_coordinates/180824/separate_IDs/H165.csv'
#output_angle_path='/home/wildhorse_project/horse_coordinates/horse_coordinates/180824/teszt_angle.txt'
#angle_calc(input_angle_path,output_angle_path)

print("Get frame IDs...", sep="")

input_coord='/home/wildhorse_project/horse_coordinates/horse_coordinates/180824/horse_coordinates.txt'
output_dir='/home/wildhorse_project/horse_coordinates/horse_coordinates/180824/separate_frames/'
#get_frame_info(input_coord, output_dir)

print("Creating list of IDs...", sep="")
IDs_list = get_IDs(input)
print("    DONE")

#Step3
print("Create coordinates...",sep="")
for i in range(1,max_frame):
    for j in range(0,len(IDs_list)):
        input_ID="".join((output2,IDs_list[j],"_coordinates_2.csv"))
        create_csv(input_ID,i,output_dir)
    print(i, "DONE",sep=" ")
print("    DONE")
    


#Step3
#print("Calculate direction vectors...",sep="")
#for i in range(0,len(IDs_list)):
#    input_angle_path="".join((output2,IDs_list[i],".csv"))
#    output_angle_path="".join((output2,IDs_list[i],"_coordinates_2.csv"))
#    direction_vector(input_angle_path,output_angle_path)
#print("    DONE")
