using System;
using System.Collections;
using System.Collections.Generic;

namespace XmlDiff
{
	public class XmlComparer
	{
		public static List<Node> CompareReturnNode (string expectedXml, string actualXml)
		{
			List<Node> resultCollection = new List<Node> ();

			XmlConverter expectedXmlConverter = new XmlConverter (expectedXml);
			List<Node> expectedNodeCollection = expectedXmlConverter.Convert ();
			
			XmlConverter actualXmlConverter = new XmlConverter (actualXml);
			List<Node> actualNodeCollection = actualXmlConverter.Convert ();
		
			resultCollection.AddRange (ChechExpected (expectedNodeCollection, actualNodeCollection));
			resultCollection.AddRange (CheckActual (actualNodeCollection));

			return resultCollection;
		}
		
		public static List<string> CompareReturnString (string expectedXml, string actualXml)
		{
			List<string> resultCollection = new List<string> ();

			XmlConverter expectedXmlConverter = new XmlConverter (expectedXml);
			List<Node> expectedNodeCollection = expectedXmlConverter.Convert ();
			
			XmlConverter actualXmlConverter = new XmlConverter (actualXml);
			List<Node> actualNodeCollection = actualXmlConverter.Convert ();
		
			resultCollection.AddRange (ToString("Expected", ChechExpected (expectedNodeCollection, actualNodeCollection)));
			resultCollection.AddRange (ToString("Actual", CheckActual (actualNodeCollection)));

			return resultCollection;
		}

		private static List<Node> ChechExpected (List<Node> expectedNodeCollection, List<Node> actualNodeCollection)
		{
			List<Node> resultCollection = new List<Node> ();

			foreach (Node expectedNode in expectedNodeCollection)
			{
				expectedNode.Compared = true;

				Node actualNode = actualNodeCollection.Find (n => n.Equals (expectedNode) && n.Compared == false);

				if (actualNode != null) {
					actualNode.Compared = true;
				} else {
					resultCollection.Add (expectedNode);
				}
			}

			return resultCollection;		
		}

		private static List<Node> CheckActual (List<Node> actualNodeCollection)
		{
			List<Node> resultCollection = new List<Node> ();
			
			List<Node> actualNotCompared = actualNodeCollection.FindAll (n => !n.Compared);
			if (actualNotCompared != null)
			{
				foreach(Node node in actualNotCompared)
				{
					resultCollection.Add (node);
				}
			}

			return resultCollection;
		}
		
		private static List<string> ToString(string prefix, List<Node> nodeCollection)
		{
			List<string> resultCollection = new List<string> ();
			
			if (nodeCollection != null)
			{
				foreach(Node node in nodeCollection)
				{
					resultCollection.Add (string.Format("{0} => {1}", prefix, node.ToString()));
				}
			}
			
			return resultCollection;
		}
	}
}