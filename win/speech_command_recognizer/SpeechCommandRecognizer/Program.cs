using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Speech.Recognition;
using System.Globalization;
using System.Threading;
using System.Speech.Synthesis;
using System.Windows.Forms;

namespace SpeechCommandRecognizer
{
    class Program
    {
        private const string AmericanSpeechId = "MS-1033-80-DESK";
        private readonly static SpeechSynthesizer speechSynthesizer = new SpeechSynthesizer();

        static void Main(string[] args)
        {
            Console.WriteLine("Start...");
            SpeechRecognitionEngine speechRecognitionEngine = null;            

            try
            {
                SpeechRecognizer spR = new SpeechRecognizer();
                spR.UnloadAllGrammars();
                spR.LoadGrammar(new DictationGrammar());
                spR.LoadGrammar(CreateGrammar());
                HookEvents(spR);
                spR.Enabled = true;

                //foreach (InstalledVoice voice in speechSynthesizer.GetInstalledVoices())
                //{
                //    Console.WriteLine("voice.Enabled: {0}; Name: {1}", voice.Enabled, voice.VoiceInfo.Name);
                //}

                //speechSynthesizer.Speak("start listening, stop listening, listen");
                //speechSynthesizer.Speak("1. I want to go home this evening.");
                //speechSynthesizer.Speak("2. I'm so fresh that I could move mountains.");
                //speechSynthesizer.Speak("3. My wife is the most beautiful woman over the world.");

                //speechRecognitionEngine = CreateSpeechRecognitionEngine();
                ////speechRecognitionEngine.UnloadAllGrammars();
                //speechRecognitionEngine.SetInputToDefaultAudioDevice();
                //speechRecognitionEngine.LoadGrammar(CreateGrammar());
                //HookEvents(speechRecognitionEngine);

                //speechRecognitionEngine.RecognizeAsync(RecognizeMode.Multiple);

                while (true)
                {
                    if (Console.KeyAvailable)
                    {
                        ConsoleKeyInfo cki = Console.ReadKey();
                        if (cki.Key == ConsoleKey.E)
                        {
                            Console.WriteLine("Pressed 'E' key to exit.");
                            //speechRecognitionEngine.RecognizeAsyncStop();
                            break;
                        }
                    }

                    Thread.Sleep(10);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            finally
            {
                Console.WriteLine("Press 'enter' to end...");
                Console.Read();
            }
        }

        private static Grammar CreateGrammar()
        {
            GrammarBuilder grammarBuilder = new GrammarBuilder();
            //grammarBuilder.Append(new Choices(
            //    "start", "stop", "start listening", "stop listening", "listen",
            //    "cut", "copy", "paste", "delete", "undo", "select", "view", "debug",
            //    "start firefox"));
            grammarBuilder.Append(new Choices(
                "start visual"));

            return new Grammar(grammarBuilder);
        }

        private static void HookEvents(SpeechRecognizer speechRecognizer)
        {
            speechRecognizer.SpeechDetected += new EventHandler<SpeechDetectedEventArgs>(speechRecognitionEngine_SpeechDetected);
            speechRecognizer.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>(speechRecognitionEngine_SpeechRecognitionRejected);
            speechRecognizer.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>(speechRecognitionEngine_SpeechHypothesized);
            speechRecognizer.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>(speechRecognitionEngine_SpeechRecognized);
        }

        private static void HookEvents(SpeechRecognitionEngine speechRecognitionEngine)
        {
            speechRecognitionEngine.SpeechDetected += new EventHandler<SpeechDetectedEventArgs>(speechRecognitionEngine_SpeechDetected);
            speechRecognitionEngine.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>(speechRecognitionEngine_SpeechRecognitionRejected);
            speechRecognitionEngine.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>(speechRecognitionEngine_SpeechHypothesized);
            speechRecognitionEngine.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>(speechRecognitionEngine_SpeechRecognized);
            speechRecognitionEngine.RecognizeCompleted += new EventHandler<RecognizeCompletedEventArgs>(speechRecognitionEngine_RecognizeCompleted);
        }

        static void speechRecognitionEngine_SpeechDetected(object sender, SpeechDetectedEventArgs e)
        {
            Console.WriteLine("SpeechDetected");
        }

        static void speechRecognitionEngine_SpeechRecognitionRejected(object sender, SpeechRecognitionRejectedEventArgs e)
        {
            Console.WriteLine("SpeechRecognitionRejected");
        }

        static void speechRecognitionEngine_SpeechHypothesized(object sender, SpeechHypothesizedEventArgs e)
        {
            Console.WriteLine("SpeechHypothesized");
        }

        static void speechRecognitionEngine_SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
        {
            Console.WriteLine("SpeechRecognized Text: {0}; Grammar: {1}; Alternates.Count: {2}",
                e.Result.Text,
                e.Result.Grammar.Name,
                e.Result.Alternates.Count);

            if (e.Result.Text.Contains("start visual"))
            {
                Console.WriteLine("Run commonad for: {0}", e.Result.Text);
                speechSynthesizer.Speak(e.Result.Text);
            }
        }

        static void speechRecognitionEngine_RecognizeCompleted(object sender, RecognizeCompletedEventArgs e)
        {
            Console.WriteLine("RecognizeCompleted Text: {0}; Alternates.Count: {1}",
                e.Result.Text,
                e.Result.Alternates.Count);
        }

        private static SpeechRecognitionEngine CreateSpeechRecognitionEngine()
        {
            RecognizerInfo americanSpeechIdRecognizerInfo = null;

            foreach (RecognizerInfo recognizerInfo in SpeechRecognitionEngine.InstalledRecognizers())
            {
                Console.WriteLine("Id: {0}; Name: {1}; Description: {2}", 
                    recognizerInfo.Id, 
                    recognizerInfo.Name, 
                    recognizerInfo.Description);

                if (recognizerInfo.Id == AmericanSpeechId)
                {
                    americanSpeechIdRecognizerInfo = recognizerInfo;                    
                }
            }

            if (americanSpeechIdRecognizerInfo != null)
            {
                return new SpeechRecognitionEngine(americanSpeechIdRecognizerInfo);
            }

            throw new InvalidOperationException(
                string.Format("Cannot create 'SpeechRecognitionEngine' for RecognizerInfo.Id: {0}.", 
                AmericanSpeechId));
        }
    }
}
