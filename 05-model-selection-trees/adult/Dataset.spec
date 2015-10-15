Title: UCI adult database. Predict if Income > or < $50k based on census data
Origin: natural

Usage: assessment

Order: uninformative

Attributes:
  1 age		u  (16,Inf]	# Person's age
  2 workclass   u Private Self-emp-not-inc Self-emp-inc Federal-gov  Local-gov State-gov Without-pay Never-worked # Work type
  3 fnlwgt      u  [-Inf,Inf]	# ??
  4 education   u Preschool 1st-4th 5th-6th 7th-8th 9th 10th 11th 12th HS-grad Assoc-acdm Assoc-voc Some-college Prof-school Bachelors Masters Doctorate # Education level
  5 educational-num u [0,Inf] #
  6 marital-status  u  Married-civ-spouse Divorced Never-married Separated Widowed Married-spouse-absent Married-AF-spouse	# 
  7 occupation  u  Tech-support Craft-repair Other-service Sales Exec-managerial Prof-specialty Handlers-cleaners Machine-op-inspct Adm-clerical Farming-fishing Transport-moving Priv-house-serv Protective-serv Armed-Forces # 
  8 relationship u Wife Own-child Husband Not-in-family Other-relative Unmarried	# 
  9 race	 u  White Asian-Pac-Islander Amer-Indian-Eskimo Other Black # 
 10 gender	 u  Female Male	# 
 11 capital-gain u [0,Inf] #
 12 capital-loss u [0,Inf] #
 13 hours-per-week u [0,168] #
 14 native-country u United-States Cambodia England Puerto-Rico Canada Germany Outlying-US(Guam-USVI-etc) India Japan Greece South China Cuba Iran Honduras Philippines Italy Poland Jamaica Vietnam Mexico Portugal Ireland France Dominican-Republic Laos Ecuador Taiwan Haiti Columbia Hungary Guatemala Nicaragua Scotland Thailand Yugoslavia El-Salvador Trinadad&Tobago Peru Hong Holand-Netherlands #
 15 income	   u <=50K >50K # Income breakpoint

