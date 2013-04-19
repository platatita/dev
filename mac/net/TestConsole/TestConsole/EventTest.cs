using System;
using System.Linq;

namespace TestConsole
{
	public delegate void StateChangeHandler(object sender, StateEventArgs sea);
	
	public class EventTest
	{
		public event StateChangeHandler StateChangeEvent;
		private int counter;

		public void Increase ()
		{
			this.counter++;

			if (StateChangeEvent != null) {
				SynStateChangeNotifier();
//				AsynStateChangeNotifier();
			}
		}

		private void SynStateChangeNotifier ()
		{
			this.StateChangeEvent (
				this, 
				new StateEventArgs ()
				{ 
				Count = this.counter,
				DelegateCount =	this.StateChangeEvent.GetInvocationList ().Length
			});
		}

		private void AsynStateChangeNotifier ()
		{
			foreach (Delegate del in this.StateChangeEvent.GetInvocationList ()) {
				StateChangeHandler sdel = del as StateChangeHandler;

				try
				{
				sdel(
					this, 
					new StateEventArgs ()
					{ 
						Count = this.counter,
						DelegateCount =	this.StateChangeEvent.GetInvocationList ().Length
					});
				}
				catch (System.Exception ex)
				{
					Console.WriteLine ("Event: {0}, throw exception: {1}", sdel.ToString (), ex.ToString ());
				}
			}
		}
	}
}

