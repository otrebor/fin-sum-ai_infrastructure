# FIN-SUM-AI Infrastructure
# Introduction 
This project collects the Bicep scripts used to setup the infrastructure on Azure for the project fin-sum-ai

# Getting Started
 you can use this project in two ways:
1.	If you want to deploy the infrastructure under an existing resource group: az deployment group create --template-file "main_rg.bicep" --resource-group Cteam8
2.	If you want to create the infrastructure under an existing subscription: az deployment sub create --template-file "main_sub.bicep" --location WestEurope

# Build and Test
az bicep build --file .\main.bicep

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)


