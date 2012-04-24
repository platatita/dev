using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Diagnostics;
using System.IO;

namespace NativeMultiThreading
{
    class Program
    {
        [MTAThread()]
        static void Main(string[] args)
        {
            Console.WriteLine("Start...");
            TextWriter tw = Console.Out;
            FileStream fs = null;

            try
            {
                fs = new FileStream("NativeResult.txt", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                StreamWriter sw = new StreamWriter(fs);
                sw.AutoFlush = true;
                Console.SetOut(sw);

                int runThreads = 2;
                int testNumber = 10;
                long nativeAffinityTime = 0;
                long nativeNoAffinityTime = 0;
                long managedNoAffinityTime = 0;

                for (int i = 0; i < testNumber; i++)
                {
                    tw.WriteLine("Test: {0}, ManagedThreadProcessing: Set affinity: false", i);
                    ManagedThreadProcessing mtp = new ManagedThreadProcessing(runThreads, i);
                    managedNoAffinityTime += mtp.Test();

                    //tw.WriteLine("Test: {0}, NativeThreadProcessing: Set affinity: false", i);
                    //NativeThreadProcessing ntp = new NativeThreadProcessing(runThreads, i, false);
                    //nativeNoAffinityTime += ntp.Test();

                    //tw.WriteLine("Test: {0}, NativeThreadProcessing: Set affinity: true", i);
                    //NativeThreadProcessing ntp2 = new NativeThreadProcessing(runThreads, i, true);
                    //nativeAffinityTime += ntp2.Test();
                }

                string log = string.Format("Native affinity average time: {0} [ms]", (float)nativeAffinityTime / testNumber);
                Console.WriteLine(log);
                tw.WriteLine(log);

                log = string.Format("Native no affinity average time: {0} [ms]", (float)nativeNoAffinityTime / testNumber);
                Console.WriteLine(log);
                tw.WriteLine(log);

                log = string.Format("Managed no affinity average time: {0} [ms]", (float)managedNoAffinityTime / testNumber);
                Console.WriteLine(log);
                tw.WriteLine(log);

                Console.SetOut(tw);
            }
            catch (Exception ex)
            {
                Console.SetOut(tw);
                Console.WriteLine(ex.ToString());
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }

                Console.WriteLine("End. Press 'enter' to end...");
                Console.Read();
            }
        }
    }
}
