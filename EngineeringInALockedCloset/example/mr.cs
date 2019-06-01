using System.Collections.Generic;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using System.Text;
using System.Threading;

    ...

        public void mapReduce(string fileText)
        {   //Reset the Blocking Collection, if already used
            if (wordChunks.IsAddingCompleted)
            {
                wordBag = new ConcurrentBag();
                wordChunks = new BlockingCollection(wordBag);
            }

            //Create background process to map input data to words
            System.Threading.ThreadPool.QueueUserWorkItem(delegate(object state)
            {
                mapWords(fileText);
            });

            //Reduce mapped words
            reduceWords();
        }