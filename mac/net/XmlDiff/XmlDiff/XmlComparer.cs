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

			foreach (Node expectedNode in expectedNodeCollection) {

				Node actualNode = actualNodeCollection.Find (n => n.Equals (expectedNode));

				if (actualNode != null) {
					actualNode.Compared = true;
				} else {
					resultCollection.Add (expectedNode.ToString ());
				}
			}

			if (resultCollection.Count > 0) {
				resultCollection.Insert (0, "Expected node/nodes not found");
				resultCollection.Insert (1, Environment.NewLine);
			}

			return resultCollection;		
		}

		private static List<string> CheckActual (List<Node> actualNodeCollection)
		{
			List<string> resultCollection = new List<string> ();
			
			List<Node> actualNotCompared = actualNodeCollection.FindAll (n => !n.Compared);
			if (actualNotCompared != null) {
				resultCollection.AddRange (actualNotCompared.ConvertAll (c => c.ToString ()));
			}

			return resultCollection;
		}
	}
}