using System;
using System.Linq;

namespace TestConsole.Events
{
	public delegate void StateChangeHandler (object sender, StateEventArgs sea);

	/// <summary>
	/// This class presents ways how to notify subscribers about state change by the event.
	/// </summary>
	public class EventModeTester
	{
		public event StateChangeHandler StateChangeEvent;

		private int counter;

		public EventModeTester (bool safeMode = false)
		{
			this.SafeMode = safeMode;
		}

		public bool SafeMode { get; set; }

		public void Increase ()
		{
			this.counter++;

			if (StateChangeEvent != null) {
				if (SafeMode) {
					SyncSafeStateChangeNotifier ();
				} else {
					SyncUnsafeStateChangeNotifier ();
				}
			}
		}

		private void SyncUnsafeStateChangeNotifier ()
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

		private void SyncSafeStateChangeNotifier ()
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

