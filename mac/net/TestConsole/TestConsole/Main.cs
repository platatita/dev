using System;

namespace TestConsole
{
	class MainClass
	{
		private static int EventCounter = 0;
		
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
			Console.WriteLine ("r - to read state");
			Console.WriteLine ("s - to stop test");
			
			bool stop = false;
			EventTest et = new EventTest ();

			while (!stop) {
				ConsoleKeyInfo cki = Console.ReadKey ();

				if (cki.Key == ConsoleKey.I) {
					et.StateChangeEvent += HandleStateChangeEvent;
					Console.WriteLine ("Pressed I");
				} else if (cki.Key == ConsoleKey.R) {
					et.Increase();
					Console.WriteLine ("Pressed R");
				} else if (cki.Key == ConsoleKey.S) {
					stop = true;
					Console.WriteLine ("Pressed S");					
				}
			}
		}

		static void HandleStateChangeEvent (object sender, StateEventArgs sea)
		{
			System.Threading.Interlocked.Increment (ref EventCounter);

			Console.WriteLine("{0}: {1}", EventCounter, sea.ToString ());

			throw new InvalidOperationException();
		}
	}
}
