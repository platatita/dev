using System;
using System.Threading;

namespace TestConsole.Threads
{
	public class ThreadLocalTest
	{		
		private static ThreadLocal<int> iterator = new ThreadLocal<int>(() => 10);

		public static void Execute ()
		{
			Console.WriteLine ("Start ThreadLocalTest");
			
			Thread t1 = new Thread(ThreadProc);
			t1.Start ();
			Thread t2 = new Thread(ThreadProc);
			t2.Start ();
			Thread t3 = new Thread(ThreadProc);
			t3.Start ();

			Thread.Sleep (1000);
			Console.WriteLine ("ThreadLocal is OK :)");
			Thread.Sleep (1000);

			Console.WriteLine ("End ThreadLocalTest");
		}
		
		private static void ThreadProc()
		{
			Console.WriteLine("ThreadId: {0} - iterator value: {1}", Thread.CurrentThread.ManagedThreadId, iterator.Value);
		}
	}
}

