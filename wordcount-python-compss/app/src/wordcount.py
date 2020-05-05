#!/usr/bin/env python
import sys

from dataclay import api, getRuntime
from pycompss.api.task import task
from pycompss.api.api import compss_barrier, compss_wait_on
from pycompss.api.parameter import IN, INOUT, OUT

from DemoNS.classes import TextCollection, TextStats

@task(text=IN,returns=object)
def wordcount_new_stats(text):
    return text.word_count()

@task(stats1=INOUT,stats2=IN)
def reduce_task_in(stats1, stats2): 
    stats1.merge_word_counts(stats2)
    
@task(stats=IN)
def wordcount(stats, index):
    #stats = TextStats.get_by_alias("TextStats")
    words = TextCollection.get_by_alias(alias)
    partial_result = words.texts[index].word_count()
    stats.merge_word_counts(partial_result)

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print ("""
    Usage:

        ./wordcount.py [text_collection_alias]
    """)
        exit(1)
    elif len(sys.argv) == 2:
        alias = sys.argv[1]
    else:
        alias = "Words"

    print(" ###############################")
    print(" # Start WordCount application #")
    print(" ###############################")

    words = TextCollection.get_by_alias(alias)

    stats = TextStats(dict())
    stats.make_persistent("TextStats")

    texts = words.texts
    total_n_texts = len(texts)

    print("Ready to count words from %d different texts" % total_n_texts)

    partial_results = []
    for text in texts:
        partial_result = text.word_count()
        partial_results.append(partial_result)

    compss_barrier()

    q = []
    for i in range(total_n_texts):
        q.append(i)

    x = 0
    while len(q) != 0:
        x = q.pop(0) # 0
        if len(q) != 0:
            y = q.pop(0) # 1
            print("Reducing partial results %i and %i to %i" % (x, y, x))
            reduce_task_in(partial_results[x], partial_results[y])
            q.append(x)
            print("q=%s" % str(q))
            # 0 = 0 + 1 q=(0, 2, 4)
            # 0 = 0 + 2 q=(0, 4)
    compss_barrier()
    stats = partial_results[x]    
        
    print(" # WordCount finished")
    print(" # Top 10:\n %s" % stats.get_summary(10))
