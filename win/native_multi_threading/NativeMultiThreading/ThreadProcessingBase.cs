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
    public abstract class ThreadProcessingBase
    {
        protected readonly int threadCount;
        protected readonly int testNumber;
        protected readonly bool setThreadAffinity;
        protected Dictionary<int, ThreadParam> threadParamCollection;

        public ThreadProcessingBase(int threadCount, int testNumber, bool setThreadAffinity)
        {
            this.threadCount = threadCount;
            this.testNumber = testNumber;
            this.setThreadAffinity = setThreadAffinity;
        }

        public virtual long Test()
        {
            Stopwatch clock = Stopwatch.StartNew();

            try
            {
                this.threadParamCollection = new Dictionary<int, ThreadParam>();

                for (int i = 0; i < this.threadCount; i++)
                {
                    string path = "..\\..\\Files\\Log1.txt";
                    if (i > 0)
                    {
                        path = "..\\..\\Files\\Log2.txt";
                    }

                    RunThread(i, path);
                }
            }
            finally
            {
                if (this.threadParamCollection != null)
                {
                    Log(string.Format("Waiting for native thread finshed..."));
                    for (int i = 0; i < this.threadParamCollection.Count; i++)
                    {
                        this.threadParamCollection[i].ManualResetEvent.WaitOne();
                    }
                }

                clock.Stop();
                Log(string.Format("Native thread testing finshed {0} [ms].", clock.ElapsedMilliseconds));
                Log(new string('-', 64));
            }

            return clock.ElapsedMilliseconds;
        }

        protected virtual void RunThread(int threadIndex, string path)
        {
            ValidatePath(path);
        }

        protected virtual void ValidatePath(string path)
        {
            if (!File.Exists(path))
            {
                throw new IOException(string.Format("Provided path '{0}' parameter does not exist.", path));
            }
        }

        protected virtual void CreateThreadParam(int threadIndex, string path)
        {
            ThreadParam ntp = new ThreadParam();
            ntp.ThreadIndex = threadIndex;
            ntp.ManualResetEvent = new ManualResetEvent(false);
            ntp.FilePath = path;

            this.threadParamCollection.Add(threadIndex, ntp);
        }

        protected virtual void ReadFile(int threadIndex)
        {
            Log(string.Format("ThreadProc ManagedThreadId: {0}, Thread index: {1}",
                Thread.CurrentThread.ManagedThreadId,
                threadIndex));

            ThreadParam ntp = this.threadParamCollection[threadIndex];
            Log(string.Format("ThreadParam: {0}", ntp.ToString()));

            ulong readLine = 0;
            for (int i = 0; i < 10; i++)
            {
                using (FileStream fs = new FileStream(ntp.FilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                {
                    StreamReader sr = new StreamReader(fs);

                    while (!sr.EndOfStream)
                    {
                        string line = sr.ReadLine();
                        readLine++;
                    }

                    sr.Close();
                }
            }

            Log(string.Format("ThreadParam ManagedThreadId: {0}, Thread index: {1}; Read lines: {2}",
                Thread.CurrentThread.ManagedThreadId,
                threadIndex,
                readLine));

            ntp.ManualResetEvent.Set();
        }

        protected void Log(string message)
        {
            Console.WriteLine("{0}\t{1}\tTest nr: {2}; Set affinity: {3}; {4}", 
                DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                this.ToString(),
                this.testNumber, 
                this.setThreadAffinity,
                message);
        }
    }
}
