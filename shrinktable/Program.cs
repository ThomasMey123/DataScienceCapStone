﻿using System;
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
            if(args.Length<2)
            {
                Console.WriteLine("Usage: shrinkTable inputfile outputfile [numberoflines=6])");
                return;
            }

            string filename = args[0];
            string destfile = args[1];
            int numberOfLines = 6;
            if(args.Length==3)
            {
                numberOfLines = Int32.Parse(args[2]);
            }

            bool collapse = false;
            if (args.Length == 4 && args[3].Equals("collapse"))
            {
                collapse = true;
            }


            Console.WriteLine("processing " + filename);
            var reader = new StreamReader(File.OpenRead(filename));
            var writer = new StreamWriter(destfile, false);

            //read header line
            var line = reader.ReadLine();
            writer.WriteLine(line);


            if(collapse == true)
            {
                shrinkCollapsed(reader,writer,numberOfLines);
            }
            else
            {
                shrink(reader, writer, numberOfLines);
            }

            reader.Close();
            writer.Close();
        }

        private static void shrinkCollapsed(StreamReader reader, StreamWriter writer, int numberOfLinesToShrink)
        {
            string word = "";
            var count = 1;
            var target = "";
            var t1 = "";
            var newline = "";

            while (!reader.EndOfStream)
            {
                var line = reader.ReadLine();
                var values = line.Split(',');

                t1 = values[0];
                var t2 = values[1];
                var freq = values[2];

                if (word.Equals(t1))
                {
                    if (count <= numberOfLinesToShrink)
                    {
                        target +=  (target.Length == 0 ? "":  " ") + t2.Trim('\"');
                    }
                    count++;
                }
                else
                {
                    if (!word.Equals(""))
                    {
                        newline = word + ",\"" + target + "\"";
                        writer.WriteLine(newline);
                    }
                    count = 1;
                    word = t1;
                    target = t2.Trim('\"');
                 }
            }
            newline = "\"" + t1 + "\",\"" + target + "\"";
            writer.WriteLine(newline);

        }

        private static void shrink(StreamReader reader, StreamWriter writer, int numberOfLines)
        {
            var word = "";
            var count = 1;
            while (!reader.EndOfStream)
            {
                var line = reader.ReadLine();
                var values = line.Split(',');

                var t1 = values[0];
                var t2 = values[1];
                var freq = values[2];

                if (word.Equals(t1))
                {
                    count++;
                }
                else
                {
                    count = 1;
                    word = t1;
                }

                if (count <= numberOfLines)
                {
                    writer.WriteLine(line);
                }
            }
        }
    }
}
