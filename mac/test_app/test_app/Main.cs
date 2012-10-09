using System;

namespace test_app
{
	class MainClass
	{
		public class BaseClass : IDisposable
		{
			#region IDisposable implementation
			void IDisposable.Dispose ()
			{
				throw new System.NotImplementedException ();
			}
			#endregion
		}

		public static void Main (string[] args)
		{
			BaseClass b = new BaseClass();
			(b as IDisposable).Dispose();

			Console.WriteLine ("Hello World!");
		}
	}
}
