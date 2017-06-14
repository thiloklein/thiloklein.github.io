---
published: true
layout: post
title: Matching Algorithms
category: [software]
tags: [game theory, matching markets, R]
comments: true
thumbnail: /viz/matching/simdaa.gif
---



#### Algorithms for matching problems


R package matchingMarkets contains code for algorithms to find stable matchings in the three most common matching problems: stable roommates, college admissions, and house allocation. <!--more-->

Matching is concerned with who transacts with whom, and how. For example, who works at which job, which students go to which school, who forms a workgroup with whom, and so on.
In matching markets, the use of money is impossible or undesirable. Market participants thus care about who they are doing business with, and prices don't necessarily do all the talking. Prominent examples include the allocation of kindergarten, school and university places, or the distribution of donor organs.

A major challenge in these markets is to design the allocation mechanism (i.e. the matching algorithm used) in a way that all participants have an incentive to reveal their true preferences. This can prevent individual participants from taking advantage of others by proceeding strategically reporting their preferences. It is also important to achieve stable and efficient allocations given the preferences of the market participants.

The open-source R package `matchingMarkets` provides efficient and robust implementations of the most useful algorithms that have now been downloaded over 18,000 times by private and institutional users. The real-world applications range from the assignment of carers and elderly people to the allocation of seminar topics to students.

See the [matchingMarkets.org](http://matchingMarkets.org) project website for package documentation, examples and installation instructions.
