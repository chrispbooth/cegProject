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
import dill
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
    def pull_from_API(self, query, count, i,return_tweets):
        return_tweets = [status for status in tweepy.Cursor(self.api.search, q=query, since="2017-11-" + str(i),  until="2017-11-" + str(i), rpp = 100).items(count)]

    def get_tweets(self, query, count):
        '''
        Main function to fetch tweets and parse them.
        '''
        # empty list to store parsed tweets
        global tweets
        tweets.append("hey buddy")
        cpdef int[200] sentPointer
        cdef int tsize = 0
        try:
            # call twitter api to fetch tweets
            #fetched_tweets = self.api.search(q = query, count = count)
            #, (self, query, 50, 6), (self, query, 50, 9)])
            p = Process(target=self.pull_from_API, args=(query, 200, 0,return_tweets))
            p.start()
            p.join()
            fetched_tweets=return_tweets
            ###fetched_tweets = [status for status in tweepy.Cursor(self.api.search, q=query, rpp = 100).items(count)]
            # parsing tweets one by one
            for i in fetched_tweets:
                # empty dictionary to store required params of a tweet
                parsed_tweet = {}
                # saving text of tweet
                parsed_tweet['text'] = fetched_tweets[i]
                print (parsed_tweet['text'])
                # saving sentiment of tweet
                sentPointer[tsize] = self.get_tweet_sentiment(fetched_tweets[i].text)
                tsize=tsize+1
                # appending parsed tweet to tweets list
                if fetched_tweets[i].retweet_count > 0:
                    # if tweet has retweets, ensure that it is appended only once
                    if parsed_tweet not in tweets:
                        tweets.append(parsed_tweet)
                else:
                    tweets.append(parsed_tweet)
                                # return parsed tweets
            return sentPointer
 
        except tweepy.TweepError as e:
            # print error (if any)
            print("Error : " + str(e))

respMain=""
tweets = []
manager=Manager()
return_tweets = manager.array()
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
    cpdef int point[200]
    point = api.get_tweets(query = 'anime -filter:links lang:en', count = 200)   
    addline("total "+str(len(tweets)))
    cdef int k =len(tweets)
    #ptweets = [tweet for tweet in tweets if tweet['sentiment'] == 1]
    cdef int i =0
    cdef int N = 0
    cdef int M = 0
    for i in prange(k, schedule='dynamic', nogil=True):
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
    app.run(host='138.197.173.59', port=6528)