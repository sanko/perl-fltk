---
layout: default
title: Documentation
categories: [page, index]
permalink: /docs
index: documentation
---
<dl id="archives">
{%for post in site.posts%}
{%  if post.categories contains 'documentation'%}
    <dd>
        <span class="archives-date">{{post.date | date:"%d"}}</span> <a href=".{{post.url}}" class="archives-post">{%if post.categories contains 'tutorial'%}Tutorial: {%endif%}{{post.title}}</a>{%if post.categories contains 'documentation'%} - {{post.abstract}}{%endif%}
    </dd>
{%      assign previous_post = post%}
{%  endunless%}
{%endfor%}
</dl>
