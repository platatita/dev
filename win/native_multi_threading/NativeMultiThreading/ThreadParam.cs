using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace NativeMultiThreading
{
    public struct ThreadParam
    {
        public int ThreadIndex;
        public ManualResetEvent ManualResetEvent;
        public string FilePath;

        public override string ToString()
        {
            return string.Format("Thread index: {0}; FilePath: {1}",
                this.ThreadIndex,
                this.FilePath);
        }
    }

}
