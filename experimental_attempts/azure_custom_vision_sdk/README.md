# Microsoft Azure Custom Vision SDK
This is a modified sample code, if you are interested in Microsoft AI services, you can find more details in the [offical site](https://azure.microsoft.com/en-us/services/cognitive-services/).
*  [Original sample](https://github.com/Azure-Samples/cognitive-services-java-sdk-samples/tree/master/Vision/CustomVision)
*  [Original code documention](https://docs.microsoft.com/en-us/azure/cognitive-services/Custom-Vision-Service/quickstarts/image-classification?pivots=programming-language-java)
## Recommended tools to test
### Preperation:
* To use the Custom Vision Service you will need to create Custom Vision Training and Prediction resources in Azure. To do so in the Azure portal, fill out the dialog window on the [Create Custom Vision](https://portal.azure.com/?microsoft_azure_marketplace_ItemHideKey=microsoft_azure_cognitiveservices_customvision#create/Microsoft.CognitiveServicesCustomVision) page to create both a Training and Prediction resource.

### Used enviroments:
* Java Version: 13.0.2
* Apache Maven Version: 3.6.0

IMPORTANT: Not tested with other environments than listed above

 How to:
1) Create a config file, which contains the following data:
```
      TrainingClientKey=<your_key_id>
      Endpoint=https://your_project_name.cognitiveservices.azure.com/
      Input_coord=/home/coordinates/coordinates.txt
      Frames_path=/home/frames/path/CustomVision/src/main/resources/resized_180817
```
2) Run the program with config file argument.
