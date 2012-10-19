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

			List<string> resultCollection = XmlComparer.CompareReturnString (expected, actual);
			Assert.AreEqual (4, resultCollection.Count);
			Assert.AreEqual("Expected => Depth: 5; Parent: Segments; Name: Segment; Text: ; Compared: True; AttrCount: 10; AttrValues: Number:2,Airline:AA,FlightNumber:6576,DepartureDate:2012-09-26,DepartureTime:10:50:00,ArrivalDate:2012-09-26,ArrivalTime:13:35:00,DepartureAirport:LHR,ArrivalAirport:FRA,BookingClass:S,", resultCollection[0]);
			Assert.AreEqual("Expected => Depth: 5; Parent: Segments; Name: Segment; Text: ; Compared: True; AttrCount: 10; AttrValues: Number:0,Airline:AA,FlightNumber:1384,DepartureDate:2012-09-18,DepartureTime:14:40:00,ArrivalDate:2012-09-18,ArrivalTime:19:55:00,DepartureAirport:BGI,ArrivalAirport:JFK,BookingClass:S,", resultCollection[1]);							 
			Assert.AreEqual("Actual => Depth: 5; Parent: Segments; Name: Segment; Text: ; Compared: False; AttrCount: 10; AttrValues: Number:0,Airline:AA,FlightNumber:1384,DepartureDate:2012-09-18,DepartureTime:14:40:00,ArrivalDate:2012-09-18,ArrivalTime:19:55:00,DepartureAirport:BGI,ArrivalAirport:JFK,BookingClass:S,", resultCollection[2]);
			Assert.AreEqual("Actual => Depth: 5; Parent: Segments; Name: Segment; Text: ; Compared: False; AttrCount: 10; AttrValues: Number:2,Airline:AA,FlightNumber:6576,DepartureDate:2012-09-26,DepartureTime:10:50:00,ArrivalDate:2012-09-26,ArrivalTime:13:35:00,DepartureAirport:LHR,ArrivalAirport:FRA,BookingClass:S,", resultCollection[3]);
		}
		
		[Test()]
		[DeploymentItem("XmlDiff.UnitTests/Xml/Case2_AttrOrderChange_OK/*.xml", "Xml/Case2_AttrOrderChange_OK")]
		public void Case2_AttrOrderChange_OK_Test ()
		{
			string expected = File.ReadAllText ("Xml/Case2_AttrOrderChange_OK/expected.xml");
			string actual = File.ReadAllText ("Xml/Case2_AttrOrderChange_OK/actual.xml");

			List<string> resultCollection = XmlComparer.CompareReturnString (expected, actual);
			Assert.AreEqual (0, resultCollection.Count);
		}
				
		[Test()]
		[DeploymentItem("XmlDiff.UnitTests/Xml/Case3_OK/*.xml", "Xml/Case3_OK")]
		public void Case3_OK_Test ()
		{
			string expected = File.ReadAllText ("Xml/Case3_OK/expected.xml");
			string actual = File.ReadAllText ("Xml/Case3_OK/actual.xml");

			List<string> resultCollection = XmlComparer.CompareReturnString (expected, actual);
			Assert.AreEqual (0, resultCollection.Count);
		}
		
		[Test()]
		[DeploymentItem("XmlDiff.UnitTests/Xml/Case4/*.xml", "Xml/Case4")]
		public void Case4_OK_Test ()
		{
			string expected = File.ReadAllText ("Xml/Case4/expected.xml");
			string actual = File.ReadAllText ("Xml/Case4/actual.xml");

			List<string> resultCollection = XmlComparer.CompareReturnString (expected, actual);
			Assert.AreEqual (0, resultCollection.Count);
		}
	}
}

