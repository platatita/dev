using System;
using TestConsole.Events;
using System.Threading;
using TestConsole.Threads;

namespace TestConsole
{
	class MainClass
	{

		public static void Main (string[] args)
		{
			Console.WriteLine ("Start...");
			
			try {
//				TestEvents();
				TestThreadStatic();
				TestThreadLocal();
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

		private static void TestThreadStatic ()
		{
			ThreadStaticTest.Execute();
		}

		private static void TestThreadLocal ()
		{
			ThreadLocalTest.Execute();
		}
	}
}
