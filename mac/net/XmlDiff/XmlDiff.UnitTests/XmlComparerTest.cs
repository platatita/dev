using System;
using NUnit.Framework;
using System.IO;
using System.Collections.Generic;

namespace XmlDiff.UnitTests
{
	[TestFixture()]
	public class XmlComparerTest
	{
		[Test()]
		[DeploymentItem("XmlDiff.UnitTests/Xml/simple1/*.xml", "Xml/simple1")]
		public void Simple1_Test ()
		{
			string expected = File.ReadAllText ("Xml/simple1/expected.xml");
			string actual = File.ReadAllText ("Xml/simple1/actual.xml");

			List<string> resultCollection = XmlComparer.Compare (expected, actual);
			Assert.AreEqual (1, resultCollection.Count);
		}
	}
}

