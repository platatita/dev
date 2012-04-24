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
    public class NativeThreadProcessing : ThreadProcessingBase
    {
        private delegate void ThreadProcHandler(IntPtr obj);
        private readonly IntPtr threadProcPointer;
        private readonly IntPtr[] threadHandleArray;

        public NativeThreadProcessing(int threadCount, int testNumber, bool setThreadAffinity)
            : base(threadCount, testNumber, setThreadAffinity)
        {
            this.threadHandleArray = new IntPtr[threadCount];

            ThreadProcHandler threadProc = new ThreadProcHandler(ThreadProc);
            this.threadProcPointer = Marshal.GetFunctionPointerForDelegate(threadProc);
        }

        public override long Test()
        {
            try
            {
                return base.Test();
            }
            finally
            {
                for (int i = 0; i < this.threadHandleArray.Length; i++)
                {
                    IntPtr hThread = this.threadHandleArray[i];

                    bool result = Native.CloseHandle(hThread);
                    if (!result)
                    {
                        base.Log(string.Format("Closing handler '{0}' for thread index '{1}' failed.",
                            hThread.ToString(), i));
                    }
                }
            }
        }

        protected override void RunThread(int threadIndex, string path)
        {
            base.RunThread(threadIndex, path);

            IntPtr hThread = CreateNativeThread(threadIndex, path);

            this.threadHandleArray[threadIndex] = hThread;

            if (base.setThreadAffinity)
            {
                SetThreadAffinity(threadIndex, hThread);
            }
        }

        private IntPtr CreateNativeThread(int threadIndex, string path)
        {
            base.CreateThreadParam(threadIndex, path);

            uint dwThreadId = 0;
            IntPtr hThread = Native.CreateThread(
                IntPtr.Zero,
                0,
                this.threadProcPointer,
                new IntPtr(threadIndex),
                0,
                out dwThreadId);

            Log(string.Format("Created native thread id: {0}", dwThreadId));

            return hThread;
        }

        private void SetThreadAffinity(int threadIndex, IntPtr hThread)
        {
            UIntPtr newThreadAffinity = new UIntPtr((uint)threadIndex + 1);
            uint result = Native.SetThreadAffinityMask(hThread, newThreadAffinity);
            if (result == 0)
            {
                int errorCode = Marshal.GetLastWin32Error();
                Log(string.Format("Thread affinity setting failed. New: {0}, Win32Error: {1}",
                    newThreadAffinity.ToString(), 
                    errorCode));
            }
            else
            {
                Log(string.Format("Thread affinity setting succeeded. Previouse: {0}, New: {1}",
                    result, 
                    newThreadAffinity.ToString()));
            }
        }

        private void ThreadProc(IntPtr obj)
        {
            base.ReadFile(obj.ToInt32());
        }
    }
}
