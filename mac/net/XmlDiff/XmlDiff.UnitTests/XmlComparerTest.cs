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
		[DeploymentItem("XmlDiff.UnitTests/Xml/Case1_MixNodes/*.xml", "Xml/Case1_MixNodes")]
		public void Case1_MixNodes_Test ()
		{
			string expected = File.ReadAllText ("Xml/Case1_MixNodes/expected.xml");
			string actual = File.ReadAllText ("Xml/Case1_MixNodes/actual.xml");

			List<string> resultCollection = XmlComparer.Compare (expected, actual);
			Assert.AreEqual (2, resultCollection.Count);
			Assert.AreEqual("Expected => Depth: 5; Parent: Segments; Name: Segment; Text: ; Compared: True; AttrCount: 10; AttrValues: Number:2,Airline:AA,FlightNumber:6461,DepartureDate:2012-09-22,DepartureTime:15:10:00,ArrivalDate:2012-09-22,ArrivalTime:17:55:00,DepartureAirport:LHR,ArrivalAirport:FRA,BookingClass:S,", resultCollection[0]);
			Assert.AreEqual("Actual => Depth: 5; Parent: Segments; Name: Segment; Text: ; Compared: False; AttrCount: 10; AttrValues: Number:2,Airline:AA,FlightNumber:6461,DepartureDate:2012-09-22,DepartureTime:15:10:00,ArrivalDate:2012-09-22,ArrivalTime:17:55:00,DepartureAirport:LHR,ArrivalAirport:FRA,BookingClass:S,", resultCollection[1]);
		}
		
		[Test()]
		[DeploymentItem("XmlDiff.UnitTests/Xml/Case2_OK/*.xml", "Xml/Case2_OK")]
		public void Case2_OK_Test ()
		{
			string expected = File.ReadAllText ("Xml/Case2_OK/expected.xml");
			string actual = File.ReadAllText ("Xml/Case2_OK/actual.xml");

			List<string> resultCollection = XmlComparer.Compare (expected, actual);
			Assert.AreEqual (0, resultCollection.Count);
		}
		
		[Test()]
		[DeploymentItem("XmlDiff.UnitTests/Xml/Case2_AttrOrderChange_OK/*.xml", "Xml/Case2_AttrOrderChange_OK")]
		public void Case2_AttrOrderChange_OK_Test ()
		{
			string expected = File.ReadAllText ("Xml/Case2_AttrOrderChange_OK/expected.xml");
			string actual = File.ReadAllText ("Xml/Case2_AttrOrderChange_OK/actual.xml");

			List<string> resultCollection = XmlComparer.Compare (expected, actual);
			Assert.AreEqual (0, resultCollection.Count);
		}
	}
}

