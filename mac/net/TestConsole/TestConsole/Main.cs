using System;

namespace TestConsole
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("Start...");
			
			try {
				TestEvents();
			} catch (System.Exception ex) {
				Console.WriteLine(ex.ToString ());
			} finally {
				Console.WriteLine ("Press enter to end...");
				Console.Read ();
			}
		}

		private static void TestEvents()
		{
			TestEventsManager.Test ();
		}
	}
}
