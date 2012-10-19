using System;
using System.Collections;
using System.Collections.Generic;

namespace XmlDiff
{
	public class XmlComparer
	{
		public static List<string> Compare (string expectedXml, string actualXml)
		{
			List<string> resultCollection = new List<string> ();

			XmlConverter expectedXmlConverter = new XmlConverter (expectedXml);
			List<Node> expectedNodeCollection = expectedXmlConverter.Convert ();
			
			XmlConverter actualXmlConverter = new XmlConverter (actualXml);
			List<Node> actualNodeCollection = actualXmlConverter.Convert ();
		
			resultCollection.AddRange (ChechExpected (expectedNodeCollection, actualNodeCollection));
			resultCollection.AddRange (CheckActual (actualNodeCollection));

			return resultCollection;
		}

		private static List<string> ChechExpected (List<Node> expectedNodeCollection, List<Node> actualNodeCollection)
		{
			List<string> resultCollection = new List<string> ();

			foreach (Node expectedNode in expectedNodeCollection)
			{
				expectedNode.Compared = true;

				Node actualNode = actualNodeCollection.Find (n => n.Equals (expectedNode) && n.Compared == false);

				if (actualNode != null) {
					actualNode.Compared = true;
				} else {
					resultCollection.Add (string.Format("{0} => {1}", "Expected", expectedNode.ToString ()));
				}
			}

			return resultCollection;		
		}

		private static List<string> CheckActual (List<Node> actualNodeCollection)
		{
			List<string> resultCollection = new List<string> ();
			
			List<Node> actualNotCompared = actualNodeCollection.FindAll (n => !n.Compared);
			if (actualNotCompared != null)
			{
				foreach(Node node in actualNotCompared)
				{
					resultCollection.Add (string.Format("{0} => {1}", "Actual", node.ToString()));
				}
			}

			return resultCollection;
		}
	}
}