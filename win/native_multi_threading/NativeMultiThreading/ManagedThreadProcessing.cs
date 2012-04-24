using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;
using System.IO;
using System.Diagnostics;

namespace NativeMultiThreading
{
    public class ManagedThreadProcessing : ThreadProcessingBase
    {
        public ManagedThreadProcessing(int threadCount, int testNumber)
            : base(threadCount, testNumber, false)
        {
        }

        protected override void RunThread(int threadIndex, string path)
        {
            base.RunThread(threadIndex, path);

            CreateThreadParam(threadIndex, path);

            Thread thread = new Thread(new ParameterizedThreadStart(ThreadProc));
            thread.Start(threadIndex);
        }

        private void ThreadProc(object obj)
        {
            base.ReadFile(Convert.ToInt32(obj));
        }
    }
}
