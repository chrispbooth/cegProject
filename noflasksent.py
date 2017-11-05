import re
import tweepy
from tweepy import OAuthHandler
from textblob import TextBlob

#Twitter API credentials
consumer_key = 'rtvP67wxMLQxGHSmmxBsCSkS2'
consumer_secret = ' xG2TNmJtQFMMFwu4LlRBSYHKyhwQK5HqrAxp0k6WTHCfv1cuTd'
access_token = '3008198358-Kduryv0qm7NvYHS1BmsXfqbGIRzDB8QQMe3rGa1'
access_token_secret = 'oTSeWtzgZBzhJ4qV9v0gY9nicM4g7SHrr5AgBd2xoBVRZ'

def clean_tweet(self, tweet):
    return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())
 
def get_tweet_sentiment(self, tweet):
    analysis = TextBlob(self.clean_tweet(tweet))
    if analysis.sentiment.polarity > 0:
        return 'positive'
    elif analysis.sentiment.polarity == 0:
        return 'neutral'
    else:
        return 'negative'
 
def get_tweets(self, query, count):
    tweets = []
    try:
        fetched_tweets = self.search(q = query,count = 100)
        for i in range(0,len(fetched_tweets)):
            parsed_tweet = {}
            parsed_tweet['text'] = fetched_tweets[i].text
            parsed_tweet['sentiment'] = get_tweet_sentiment(fetched_tweet[i].text)
            f = open('DEBUG.txt','w')
            f.write(fetched_tweet[i].text)
            f.close()
            if fetched_tweets[i].retweet_count > 0:
                if parsed_tweet not in tweets:
                    tweets.append(parsed_tweet)
            else:
                tweets.append(parsed_tweet)
        return tweets
    except tweepy.TweepError as e:
        print("Error : " + str(e))

def addline(aLine):
    global respMain
    respMain=respMain+"\r\n<br />"+aLine
    return
 
def main():
    global respMain
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    api = tweepy.API(auth)
    tweets = get_tweets(self = api, query = 'Engineer', count = 5000)
    addline("total"+str(len(tweets)))
    ptweets = [tweet for tweet in tweets if tweet['sentiment'] == 'positive']
    addline("positive"+str(float(len(ptweets))/float(len(tweets))))
    addline("Positive tweets percentage: "+''.format(100*len(ptweets)/len(tweets)))
    ntweets = [tweet for tweet in tweets if tweet['sentiment'] == 'negative']
    addline("negative"+str(float(len(ntweets))/float(len(tweets))))    
    addline("Negative tweets percentage: "+''.format(100*len(ntweets)/len(tweets)))
    addline("========================================================================")
    for tweet in tweets:
        addline(tweet['text'])
    addline("========================================================================")
    global respMain
    genRank = respMain
    respMain = ""
    f = open('sentiment.txt','w')
    f.write(genRank)
    f.close()
    return genRank
if __name__ == '__main__':
    main()