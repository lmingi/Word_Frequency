# Word_Frequency

Author : Mingi Lee, Brahmanyapura Govind, and Pranjal Drall

The goal of our project is to produce plots that show which group uses a particular word more frequently. Our final procedure takes in a word as an input and produces a plot showing which group uses the word more. It is important to note that the plot does not show the frequency of the word but how much it’s used relative to other groups. 


Since our final procedure allows for any word that’s in the dataset as an input, a large number of conclusions about various words can be drawn. For instance, an interesting result was that Democratic Males said the word “Wall,” at a much higher rate than any other group. 

We produced two plots based the following datasets and categorical variables:

    Presidential Inaugural Addresses

        x-axis - Party of President: Democrat/Republican 

        y-axis - Time Period: Pre 1932/Post 1932

    2016 US Presidential Debates:

        x-axis - Party of Candidate: Democrat/Republican

        y-axis - Gender of Candidate: Male/Female


Our project starts with four files, each corresponding to a particular category. For instance, for the Presidential Address dataset, we made four .csv files (see attached). Then we use, my-tally to create a list of lists of most frequent words and the corresponding frequency. Use assoc-ci, we check how many times a word appears in each of the four files. Next, we use pair to convert these four tallies into a pair which represents the x and y coordinate. And lastly, we simply plot this point on the graph along with the x and y axes to make it easier to see which quadrant the point falls in.  

Instructions:

    Change the file addresses of the eight .csv files in the code to match with the address in your computer. 

    Run presidents str or candidates str, where str is a word that you want to plot, in the interactions page. This will output a plot.