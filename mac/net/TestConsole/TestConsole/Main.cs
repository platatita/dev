using System;

namespace TestConsole
{
	class MainClass
	{
		private static int EventCounter = 0;
		private static bool throwException = false;

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

		private static void TestEvents ()
		{
			DisplayHelp ();			
			
			bool stop = false;
			EventTester eventTest = new EventTester ();

			while (!stop) {
				ConsoleKeyInfo cki = Console.ReadKey ();
				Console.WriteLine (" - Pressed {0}", cki.KeyChar);				

				if (cki.Key == ConsoleKey.A) {
					eventTest.StateChangeEvent += HandleStateChangeEvent;
				} else if (cki.Key == ConsoleKey.M) {
					eventTest.StateChangeEvent -= HandleStateChangeEvent;
				} else if (cki.Key == ConsoleKey.R) {
					eventTest.Increase ();
				} else if (cki.Key == ConsoleKey.S) {
					stop = true;
				} else if (cki.Key == ConsoleKey.T) {
					throwException = !throwException;
				} else if (cki.Key == ConsoleKey.Q) {
					eventTest.SafeMode = !eventTest.SafeMode;
				} else if (cki.Key == ConsoleKey.H) {
					DisplayHelp ();
				}
			}
		}

		static void DisplayHelp ()
		{
			Console.WriteLine("Help :)");
			Console.WriteLine ("h - to display help");			
			Console.WriteLine ("a - to subscribe user");
			Console.WriteLine ("m - to subtract user");
			Console.WriteLine ("r - to notify subscribers");
			Console.WriteLine ("s - to stop application");
			Console.WriteLine ("t - to switch on/off throwing exception inside the event handler method");
			Console.WriteLine ("q - to switch on/off safe mode of Event testing");
		}

		static void HandleStateChangeEvent (object sender, StateEventArgs sea)
		{
			System.Threading.Interlocked.Increment (ref EventCounter);

			Console.WriteLine ("{0}: {1}", EventCounter, sea.ToString ());

			if (throwException) {
				throw new InvalidOperationException ();
			}
		}
	}
}
