#!/usr/bin/env python
# coding: utf-8

# # setup

# In[1]:


import os
import argparse
import numpy as np


# In[2]:


VECTOR_FILE = "/veld/input/" + os.getenv("in_vector_file") 
print(f"VECTOR_FILE: {VECTOR_FILE}")


# In[3]:


VECTORS = {}
with open(VECTOR_FILE, 'r') as f:
    for line in f:
        vals = line.rstrip().split(' ')
        VECTORS[vals[0]] = np.array([float(x) for x in vals[1:]])


# # functions

# In[4]:


def get_cosine_similarity_of_vectors(v1, v2):
    return np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2))


# In[5]:


def get_cosine_similarity_of_words(w1, w2):
    v1 = VECTORS[w1.lower()]
    v2 = VECTORS[w2.lower()]
    return get_cosine_similarity_of_vectors(v1, v2)


# In[6]:


def get_nearest_words_of_vector(v1, limit_results=None):
    comparisons = []
    for w2, v2 in VECTORS.items():
        comparisons.append((w2, get_cosine_similarity_of_vectors(v1, v2)))
    comparisons = sorted(comparisons, key=lambda x: -x[1])        
    if limit_results is not None:
        comparisons = comparisons[:limit_results]
    return comparisons


# In[7]:


def get_nearest_words_of_word(w1, limit_results=None):
    v1 = VECTORS[w1.lower()]
    return get_nearest_words_of_vector(v1, limit_results)


# # testing

# In[8]:


w1 = "frau"
w2 = "mann"


# In[9]:


v1 = VECTORS[w1]
print(v1.shape)
print(v1)
v2 = VECTORS[w2]
print(v2.shape)
print(v2)


# In[10]:


print(get_cosine_similarity_of_words(w1, w2))


# In[11]:


get_nearest_words_of_word(w1, limit_results=20)


# In[12]:


get_nearest_words_of_word(w2, limit_results=20)

