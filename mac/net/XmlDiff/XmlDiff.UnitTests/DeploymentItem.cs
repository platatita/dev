using System;
using System.IO;
using System.Reflection;

namespace XmlDiff.UnitTests
{
 	[AttributeUsage(AttributeTargets.Method, AllowMultiple = true, Inherited = false)]
	public class DeploymentItem : System.Attribute 
	{
	    public DeploymentItem(string fileProjectRelativePath, string destinationFolder)
		{
			string combinedDestinationFolder = Path.Combine(Environment.CurrentDirectory, destinationFolder);
			DeleteFileInDestinatinFolder(combinedDestinationFolder);
			if (fileProjectRelativePath.Contains("*"))
			{
				DeployItems(fileProjectRelativePath, destinationFolder);
			}
			else
			{
				DeployItem(fileProjectRelativePath, destinationFolder);
			}
	    }
		
		private static void DeployItems(string fileProjectRelativePath, string destinationFolder)
		{
			string projectPath = GetProjectPath(fileProjectRelativePath);
			string fileProjectRelativeDir = Path.GetDirectoryName(fileProjectRelativePath);
			string sourceDirPath = Path.Combine(projectPath, fileProjectRelativeDir);
			string searchPattern = fileProjectRelativePath.Substring(fileProjectRelativePath.LastIndexOf('/') + 1);
				
			string[] fileNameArray = Directory.GetFiles(sourceDirPath, searchPattern);
			foreach(string fileNamePath in fileNameArray)
			{
				string selectedFileName = Path.GetFileName(fileNamePath);
				string filePath = Path.Combine(fileProjectRelativeDir, selectedFileName);
				DeployItem(filePath, destinationFolder);
			}
		}
		
		private static void DeployItem(string fileProjectRelativePath, string destinationFolder)
		{
			string fileName = Path.GetFileName(fileProjectRelativePath);
	    	string projectPath = GetProjectPath(fileProjectRelativePath);
			
			string combinedDestinationFolder = Path.Combine(Environment.CurrentDirectory, destinationFolder);
	    	string sourceFilePath = Path.Combine(projectPath, fileProjectRelativePath);
	    	string destinationFilePath = Path.Combine(combinedDestinationFolder, fileName);
	    	
	    	CreateDestinationFolder(combinedDestinationFolder);
	    	CopySourceFileToDestination(sourceFilePath, destinationFilePath);
		}
		
		private static string GetProjectPath(string fileProjectRelativePath)
		{
			string fileProjectRelativeDir = Path.GetDirectoryName(fileProjectRelativePath);
			
			string[] dirPathArray = fileProjectRelativeDir.Split('/');
			int projectPathIndex = Environment.CurrentDirectory.IndexOf(dirPathArray[0]);
			
	    	return Environment.CurrentDirectory.Substring(0, projectPathIndex);
		}
		
		private static void DeleteFileInDestinatinFolder(string combinedDestinationFolder)
		{
	    	if (Directory.Exists(combinedDestinationFolder))
	    	{
	    		Directory.Delete(combinedDestinationFolder, true);
	    	}
		}
		
		private static void CreateDestinationFolder(string combinedDestinationFolder)
		{
	    	if (!Directory.Exists(combinedDestinationFolder))
	    	{
	    		Directory.CreateDirectory(combinedDestinationFolder);
	    	}
		}
				
		private static void CopySourceFileToDestination(string sourceFilePath, string destinationFilePath)
		{
	    	File.Copy(sourceFilePath, destinationFilePath);
		}
	}
}

