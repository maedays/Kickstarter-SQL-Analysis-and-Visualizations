# Kickstarter-SQL-Analysis
This study on Kickstarter campaign categories centers on the question: Of the Kickstarter categories with highly successful campaigns, what seems more important—lots of backers, higher individual contributions, or both?


## Tools
**Language:** SQL

**Database Engine:** SQLite

**Visuals:** Power BI

**Database:** https://www.kaggle.com/datasets/kemical/kickstarter-projects


## Findings
**1. Campaign Outcomes**

Performance art has the highest rate of success, with dance and theater finding at least a 60% chance of success. However, both also are on the smaller side, with dance only having 3768 campaigns total. 

**2. Backers**

Technology, games, and design have the largest average number of backers. However, these are likely due to extreme outliers, as their median number of backers is much more modest (compare an average of 814 backers versus a median of 29 for games). These categories specifically do not have exceptionally high success rates, however there is still an upward trend between a high number of backers and the rate of success per category. As for the average contribution per backer, design and technology both top the charts while games lingers on the lower end of the spectrum. 

**3. Funding Performance**

Games, music, and technology best meet their funding goals on average, making more than 10x their goals. However, it is important to note that technology has a very low success rate, at about 19%. Additionally, although dance and theater have high success rates, they also lag towards the very end in terms of the average percent of their goals ending up funded. 


## Conclusion

Although there is a trend in a higher rate of success for categories that attract more backers, there is stronger evidence to suggest that categories that receive the most funding are those who attract backers who pledge high contributions. 


