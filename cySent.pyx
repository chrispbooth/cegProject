import re
import tweepy
import time
import cython
from tweepy import OAuthHandler
from textblob import TextBlob
from flask import Flask
from cython.parallel import prange
import multiprocessing as mp
from  multiprocessing import Process
from multiprocessing import Manager
import json
#import numpy
#from numpy cimport ndarray as ar
cimport openmp
from cpython cimport array
import array
from itertools import product
app = Flask(__name__)
 
class TwitterClient(object):
    '''
    Generic Twitter Class for sentiment analysis.
    '''
    def __init__(self):
        '''
        Class constructor or initialization method.
        '''
        # keys and tokens from the Twitter Dev Console
        consumer_key = '3OOyW4Z3eDDy5me2QRLtcRCGk'
        consumer_secret = 'b5mDtuukQXIGFo1suPiDUeui2ql05HmujQv6eXjfjd4Xy3m7Dq'
        access_token = '3008198358-Kduryv0qm7NvYHS1BmsXfqbGIRzDB8QQMe3rGa1'
        access_token_secret = 'oTSeWtzgZBzhJ4qV9v0gY9nicM4g7SHrr5AgBd2xoBVRZ'
 
        # attempt authentication
        try:
            # create OAuthHandler object
            self.auth = OAuthHandler(consumer_key, consumer_secret)
            # set access token and secret
            self.auth.set_access_token(access_token, access_token_secret)
            # create tweepy API object to fetch tweets
            self.api = tweepy.API(self.auth)
        except:
            print("Error: Authentication Failed")
 
    def clean_tweet(self, tweet):
        '''
        Utility function to clean tweet text by removing links, special characters
        using simple regex statements.
        '''
        return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())
 
    def get_tweet_sentiment(self, tweet):
        '''
        Utility function to classify sentiment of passed tweet
        using textblob's sentiment method
        '''
        # create TextBlob object of passed tweet text
        cdef int norman =2
        analysis = TextBlob(self.clean_tweet(tweet))
        # set sentiment
        if analysis.sentiment.polarity > 0:
            norman = 1
            return norman
        elif analysis.sentiment.polarity == 0:
            norman = 2
            return norman
        else:
            norman = 0 
            return norman
    def pull_from_API(self, query, count,return_tweets,procm):
        
        muhtweets = [status for status in tweepy.Cursor(self.api.search, q=query, rpp = 100).items(count)]
        #since="2017-11-" + str(i),  until="2017-11-" + str(j), 
        itc=0
        d=return_tweets
        for tweet in muhtweets:
            if tweet.retweet_count> 0:
                if tweet.text not in d.values():
                    ritc = str(itc)+"rt"+procm
                    d[ritc]=tweet.text   
            else :
                ritc = str(itc)+procm
                d[ritc]=tweet.text
            itc=itc+1
        return_tweets.update(d)

        
    def get_tweets(self, query, count):
        '''
        Main function to fetch tweets and parse them.
        '''
        # empty list to store parsed tweets
        global tweets
        return_tweets.clear()
        tweets.clear()
        cpdef int[3000] sentPointer
        cdef int tsize = 0
        try:
            # call twitter api to fetch tweets
            #fetched_tweets = self.api.search(q = query, count = count)
            #, (self, query, 50, 6), (self, query, 50, 9)])

            p1 = Process(target=self.pull_from_API, args=(query+"since:2017-12-05 until:2017-12-06", 100, return_tweets,"p1"))
            p2 = Process(target=self.pull_from_API, args=(query+"since:2017-12-04 until:2017-12-05", 100, return_tweets,"p2"))
            p3 = Process(target=self.pull_from_API, args=(query+"since:2017-12-03 until:2017-12-04", 100, return_tweets,"p3"))
            p4 = Process(target=self.pull_from_API, args=(query+"since:2017-12-02 until:2017-12-03", 100, return_tweets,"p4"))
            p5 = Process(target=self.pull_from_API, args=(query+"since:2017-12-01 until:2017-12-02", 100, return_tweets,"p5"))
            p6 = Process(target=self.pull_from_API, args=(query+"since:2017-11-30 until:2017-12-01", 100, return_tweets,"p6"))
            p7 = Process(target=self.pull_from_API, args=(query+"since:2017-11-29 until:2017-11-30", 100, return_tweets,"p7"))
            p8 = Process(target=self.pull_from_API, args=(query+"since:2017-11-28 until:2017-11-29", 100, return_tweets,"p8"))
            p9 = Process(target=self.pull_from_API, args=(query+"since:2017-11-27 until:2017-11-28", 100, return_tweets,"p9"))
            p10 = Process(target=self.pull_from_API, args=(query+"since:2017-11-26 until:2017-11-27", 100, return_tweets,"p10"))
            p11 = Process(target=self.pull_from_API, args=(query+"since:2017-11-25 until:2017-11-26", 100, return_tweets,"p11"))
            p12 = Process(target=self.pull_from_API, args=(query+"since:2017-11-24 until:2017-11-25", 100, return_tweets,"p12"))
            p13 = Process(target=self.pull_from_API, args=(query+"since:2017-11-23 until:2017-11-24", 100, return_tweets,"p13"))
            p14 = Process(target=self.pull_from_API, args=(query+"since:2017-11-22 until:2017-11-23", 100, return_tweets,"p14"))
            p15 = Process(target=self.pull_from_API, args=(query+"since:2017-11-21 until:2017-11-22", 100, return_tweets,"p15"))
            p16 = Process(target=self.pull_from_API, args=(query+"since:2017-11-20 until:2017-11-21", 100, return_tweets,"p16"))
            p17 = Process(target=self.pull_from_API, args=(query+"since:2017-11-19 until:2017-11-20", 100, return_tweets,"p17"))
            p18 = Process(target=self.pull_from_API, args=(query+"since:2017-11-18 until:2017-11-19", 100, return_tweets,"p18"))
            p19 = Process(target=self.pull_from_API, args=(query+"since:2017-11-17 until:2017-11-18", 100, return_tweets,"p19"))
            p20 = Process(target=self.pull_from_API, args=(query+"since:2017-11-16 until:2017-11-17", 100, return_tweets,"p20"))
            p21 = Process(target=self.pull_from_API, args=(query+"since:2017-11-15 until:2017-11-16", 100, return_tweets,"p21"))
            p22 = Process(target=self.pull_from_API, args=(query+"since:2017-11-14 until:2017-11-15", 100, return_tweets,"p22"))
            p23 = Process(target=self.pull_from_API, args=(query+"since:2017-11-13 until:2017-11-14", 100, return_tweets,"p23"))
            p24 = Process(target=self.pull_from_API, args=(query+"since:2017-11-12 until:2017-11-13", 100, return_tweets,"p24"))
            p25 = Process(target=self.pull_from_API, args=(query+"since:2017-11-11 until:2017-11-12", 100, return_tweets,"p25"))
            p26 = Process(target=self.pull_from_API, args=(query+"since:2017-11-10 until:2017-11-11", 100, return_tweets,"p26"))
            p27 = Process(target=self.pull_from_API, args=(query+"since:2017-11-09 until:2017-11-10", 100, return_tweets,"p27"))
            p28 = Process(target=self.pull_from_API, args=(query+"since:2017-11-08 until:2017-11-09", 100, return_tweets,"p28"))
            p29 = Process(target=self.pull_from_API, args=(query+"since:2017-11-07 until:2017-11-08", 100, return_tweets,"p29"))
            p30 = Process(target=self.pull_from_API, args=(query+"since:2017-11-06 until:2017-11-07", 100, return_tweets,"p30"))
            p1.start()
            p2.start()
            p3.start()
            p4.start()
            p5.start()
            p6.start()
            p7.start()
            p8.start()
            p9.start()
            p10.start()
            p11.start()
            p12.start()
            p13.start()
            p14.start()
            p15.start()
            p16.start()
            p17.start()
            p18.start()
            p19.start()
            p20.start()
            p21.start()
            p22.start()
            p23.start()
            p24.start()
            p25.start()
            p26.start()
            p27.start()
            p28.start()
            p29.start()
            p30.start()
            p1.join()
            p2.join()
            p3.join()
            p4.join()
            p5.join()
            p6.join()
            p7.join()
            p8.join()
            p9.join()
            p10.join()
            p11.join()
            p12.join()
            p13.join()
            p14.join()
            p15.join()
            p16.join()
            p17.join()
            p18.join()
            p19.join()
            p20.join()            
            p21.join()
            p22.join()
            p23.join()
            p24.join()
            p25.join()
            p26.join()
            p27.join()
            p28.join()
            p29.join()
            p30.join()
            fetched_tweets=return_tweets
            ###fetched_tweets = [status for status in tweepy.Cursor(self.api.search, q=query, rpp = 100).items(count)]
            # parsing tweets one by one
            for value in fetched_tweets.values():
                # empty dictionary to store required params of a tweet
                #parsed_tweet = {}
                # saving text of tweet
                #parsed_tweet['text'] = fetched_tweets[key]
                #print (parsed_tweet['text'])
                # saving sentiment of tweet
                sentPointer[tsize] = self.get_tweet_sentiment(str(value))
                tsize=tsize+1
                # appending parsed tweet to tweets list
                #if "rt" not in key:
                    # if tweet has retweets, ensure that it is appended only once
                if value not in tweets:
                    tweets.append(str(value))
                else:
                    tweets.append(str(value))
                                # return parsed tweets
            
            return sentPointer
 
        except tweepy.TweepError as e:
            # print error (if any)
            print("Error : " + str(e))

respMain=""
manager=Manager()
return_tweets = manager.dict()
return_tweets.clear()
tweets =[]

def addline(aLine):
    global respMain
    respMain=respMain+"\r\n<br />"+aLine
    return


#@Cython.boundscheck(False)
#@Cython.wraparound(False)
#def parallelPositiveTweets(int* param, int k):
#    cdef int i
#    cdef int N = 0
#    for i in prange(k, schedule='static', nogil=True):
#        N = N +(param[i]==1)
#    return N
def main():
    global tweets
    # creating object of TwitterClient Class
    myTime = time.time()
    api = TwitterClient()
    # calling function to get tweets
    cpdef int point[3000]
    point = api.get_tweets(query = 'engineering lang:en', count = 3000)   
    addline("total "+str(len(tweets)))
    cdef int k =len(tweets)
    #ptweets = [tweet for tweet in tweets if tweet['sentiment'] == 1]
    cdef int i =0
    cdef int N = 0
    cdef int M = 0
    for i in prange(k, schedule='dynamic', nogil=True, num_threads=120):
        N += (point[i]==1)
        M += (point[i]==0)
    ptweets = N
    ntweets = M
    #ptweets = parallelPositiveTweets(*point, k)
    #addline("positive "+str(float(len(ptweets))/float(len(tweets))))
    addline("positive "+str(float(ptweets)/float(len(tweets))))
    # percentage of positive tweets
    addline("Positive tweets percentage: "+''.format(100*ptweets/len(tweets)))
    # picking negative tweets from tweets
    ######ntweets = [tweet for tweet in tweets if tweet['sentiment'] == 0]
    #i = 0
    #for i in prange(k, schedule='dynamic', nogil=True):
    #ntweets = M
    # percentage of negative tweets
    addline("negative "+str(float(ntweets)/float(len(tweets))))    
    addline("Negative tweets percentage: "+''.format(100*ntweets/len(tweets)))
    # percentage of neutral tweets
    #print("Neutral tweets percentage: "+''.format(100*len(tweets - ntweets - ptweets)/len(tweets)))
    addline("========================================================================")
    for i in range(len(tweets)):
        addline(tweets[i])
    addline("========================================================================")
    addline("Time is: " + str(time.time()-myTime))
    f = open('Sentiment.txt','w')
    f.write(respMain)
    f.close()
    global respMain
    genRank = respMain
    respMain = ""
    return genRank
@app.route('/')
def hello_world():
    return main()
def startwebapp():
    app.run(host='138.197.130.166', port=6528)