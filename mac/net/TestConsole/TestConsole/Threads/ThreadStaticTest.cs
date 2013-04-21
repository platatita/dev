using System;
using System.Threading;

namespace TestConsole.Threads
{
	public class ThreadStaticTest
	{		
		[ThreadStatic]
		private static int iterator = 10;

		public static void Execute ()
		{
			Console.WriteLine ("Start ThreadStatic");
			Thread t1 = new Thread(ThreadProc);
			t1.Start ();
			Thread t2 = new Thread(ThreadProc);
			t2.Start ();
			Thread t3 = new Thread(ThreadProc);
			t3.Start ();

			Thread.Sleep (1000);
			Console.WriteLine ("Surprised? Why iterator equals to '0' instead of 10?");
			Thread.Sleep (2000);
			Console.WriteLine ("End ThreadStatic");
		}
		
		private static void ThreadProc()
		{
			Console.WriteLine("ThreadId: {0} - iterator value: {1}", Thread.CurrentThread.ManagedThreadId, iterator);
		}
	}
}

