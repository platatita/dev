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
			Console.WriteLine("Insert key: ");
			Console.WriteLine ("a - to add event");
			Console.WriteLine ("m - to subtract event");
			Console.WriteLine ("r - to read state");
			Console.WriteLine ("s - to stop test");
			Console.WriteLine ("t - to throw exception while reading state");
			
			bool stop = false;
			EventTest et = new EventTest ();

			while (!stop) {
				ConsoleKeyInfo cki = Console.ReadKey ();
				Console.WriteLine (" - Pressed {0}", cki.KeyChar);				

				if (cki.Key == ConsoleKey.A) {
					et.StateChangeEvent += HandleStateChangeEvent;
				} else if (cki.Key == ConsoleKey.M) {
					et.StateChangeEvent -= HandleStateChangeEvent;
				} else if (cki.Key == ConsoleKey.R) {
					et.Increase();
				} else if (cki.Key == ConsoleKey.S) {
					stop = true;
				} else if (cki.Key == ConsoleKey.T) {
					throwException = !throwException;
				}
			}
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
