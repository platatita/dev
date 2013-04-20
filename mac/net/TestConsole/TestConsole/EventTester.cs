using System;
using System.Linq;

namespace TestConsole
{
	public delegate void StateChangeHandler (object sender, StateEventArgs sea);
	
	public class EventTester
	{
		public event StateChangeHandler StateChangeEvent;

		private int counter;

		public EventTester (bool safeMode = false)
		{
			this.SafeMode = safeMode;
		}

		public bool SafeMode { get; set; }

		public void Increase ()
		{
			this.counter++;

			if (StateChangeEvent != null) {
				if (SafeMode) {
					SynSafeStateChangeNotifier ();
				} else {
					SynUnsafeStateChangeNotifier ();
				}
			}
		}

		private void SynUnsafeStateChangeNotifier ()
		{
			long startTicks = DateTime.Now.Ticks;

			Console.WriteLine ("Start unsafe mode of notification");
			this.StateChangeEvent (
				this, 
				new StateEventArgs ()
				{ 
				Count = this.counter,
				DelegateCount =	this.StateChangeEvent.GetInvocationList ().Length
			});
			Console.WriteLine ("End unsafe mode of notification: {0} ticks", DateTime.Now.Ticks - startTicks);
		}

		private void SynSafeStateChangeNotifier ()
		{
			long startTicks = DateTime.Now.Ticks;
			
			Console.WriteLine ("Start safe mode of notification");
			
			Delegate[] dels = this.StateChangeEvent.GetInvocationList ();

			for (int i = 0; i < dels.Length; i++) {
				Delegate del = dels [i];
				StateChangeHandler sdel = del as StateChangeHandler;

				try {
					sdel (
						this, 
						new StateEventArgs ()
						{ 
							Count = this.counter,
							DelegateCount =	this.StateChangeEvent.GetInvocationList ().Length
						});

				} catch (System.Exception ex) {
					Console.WriteLine ("Event: {0}, throw exception: {1}", sdel.ToString (), ex.ToString ());
				}			
			}

			Console.WriteLine ("End safe mode of notification: {0} ticks", DateTime.Now.Ticks - startTicks);
		}
	}
}

