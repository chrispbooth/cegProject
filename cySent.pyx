import re
import tweepy
import time
import Cython
from tweepy import OAuthHandler
from textblob import TextBlob
from flask import Flask
from Cython import parallel, prange
#import numpy
#from numpy cimport ndarray as ar
cimport openmp
from cpython cimport array
import array

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
        analysis = TextBlob(self.clean_tweet(tweet))
        # set sentiment
        if analysis.sentiment.polarity > 0:
            return 1
        elif analysis.sentiment.polarity == 0:
            return None
        else:
            return 0
    
    def get_tweets(self, query, count):
        '''
        Main function to fetch tweets and parse them.
        '''
        # empty list to store parsed tweets
        tweets = []
        cpdef int[400] sentPointer
        cdef int tsize = 0
        try:
            # call twitter api to fetch tweets
            #fetched_tweets = self.api.search(q = query, count = count)
            fetched_tweets = [status for status in tweepy.Cursor(self.api.search, q=query, rpp = 100).items(count)]
            tsize = len(fetched_tweets)
            # parsing tweets one by one
            for tweet in fetched_tweets:
                # empty dictionary to store required params of a tweet
                parsed_tweet = {}
 
                # saving text of tweet
                parsed_tweet['text'] = tweet.text
                # saving sentiment of tweet
                sentPointer[tsize] = self.get_tweet_sentiment(tweet.text)
                tsize=tsize+1
                # appending parsed tweet to tweets list
                if tweet.retweet_count > 0:
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
    cpdef int point[400]
    point = api.get_tweets(query = 'anime -filter:links lang:en', count = 400)   
    addline("total "+str(len(tweets)))
    cdef int k =len(tweets)
    #ptweets = [tweet for tweet in tweets if tweet['sentiment'] == 1]
    cdef int i
    cdef int N = 0
    for i in prange(k, schedule='static', nogil=True):
        N = N +(point[i]==1)
    ptweets = N
    #ptweets = parallelPositiveTweets(*point, k)
    #addline("positive "+str(float(len(ptweets))/float(len(tweets))))
    addline("positive "+str(float(ptweets)/float(len(tweets))))
    # percentage of positive tweets
    addline("Positive tweets percentage: "+''.format(100*len(ptweets)/len(tweets)))
    # picking negative tweets from tweets
    ntweets = [tweet for tweet in tweets if tweet['sentiment'] == 0]
    # percentage of negative tweets
    addline("negative "+str(float(len(ntweets))/float(len(tweets))))    
    addline("Negative tweets percentage: "+''.format(100*len(ntweets)/len(tweets)))
    # percentage of neutral tweets
    #print("Neutral tweets percentage: "+''.format(100*len(tweets - ntweets - ptweets)/len(tweets)))
    addline("========================================================================")
    for tweet in tweets:
        addline(tweet['text'])
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
if __name__ == "__main__":
    # calling main function
   app.run(host='138.197.158.105', port=6528)