using System;
using System.Collections.Generic;
using System.Text;

namespace XmlDiff
{
	internal class Root : Node
	{
		internal Root()
			: base()
		{
		}
		
		public override string Name 
		{
			get { return "Root"; }
			set { throw new InvalidOperationException(); }
		}
		
		public override string ToString ()
		{
			return "Root";
		}
	}
}

