using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace shrinkTable
{
    class Program
    {
        static void Main(string[] args)
        {
            string filename = args[0];

            Console.WriteLine("processing " + filename);
            var reader = new StreamReader(File.OpenRead(filename));
            var writer = new StreamWriter("shrunk_"+filename, false);
            var doShrink = true;

            //read header line
            var line = reader.ReadLine();

            var word = "";
            var count = 1;
            while (!reader.EndOfStream)
            {
                line = reader.ReadLine();
                var values = line.Split(',');

                var t1 = values[0];
                var t2 = values[1];
                var freq = values[2];

                if(word.Equals(t1))
                {
                    count++;
                }
                else
                {
                    count = 1;
                    word = t1;
                }

                if(doShrink)
                {
                    if(count<=10)
                    {
                        writer.WriteLine(line);
                    }
                }
                else
                {
                    writer.WriteLine(line + "," + count);
                }

            }

            reader.Close();
            writer.Close();
        }
    }
}
