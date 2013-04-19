using System;

namespace TestConsole
{
	public class StateEventArgs : EventArgs
	{
		public int Count { get; set; }
		public int DelegateCount { get; set; }

		public override string ToString ()
		{
			return string.Format ("[StateEventArgs: Count={0}, DelegateCount={1}]", Count, DelegateCount);
		}
	}
}

