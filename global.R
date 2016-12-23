library("ggplot2")
library("plotly")
library("plyr")
library("gdata")
library(shiny)
library(Cairo)
library(corrplot)
library(mgcv)

#load the dataset and features
dataset <- read.csv(file = "data.csv", header=T, sep=",")
featext <- read.csv(file="feat.csv", header = T, sep=",")


#pressure & sd of users

smallset<-dataset[sample(nrow(dataset),10000),]

#Taking phone id and pressure
dataS1<-smallset[c(2,9,6)]
#dataS1<-dataset[c(2,9)]
dataS1$ph_ori[dataS1$ph_ori == 1] <- "Portrait"
dataS1$ph_ori[dataS1$ph_ori == 2] <- "Landscape"
#Calculate mean & standard deviation of pressure for every user
phset<-ddply(dataS1, .(uid), summarise, prsr_mean=mean(pressure), prsr_sd=sd(pressure))

#Plot mean & sd points of pressure for every users (ID: 0 to 40)
p <- ggplot(dataS1, aes(x=uid, y=pressure, color=factor(ph_ori))) + 
  labs(x = "User ID",
       y = "Pressure & Standard Deviation",
       color = "Phone Orientation") +
  geom_point() + ggtitle("Pressure & Standard Deviation Points of all users")+
  geom_point(data=phset, aes(y=prsr_sd), color='orange', size=4) + 
  geom_point(data=phset, aes(y=prsr_mean), color='black', size=4)

press_sd <- p + labs(title = "Pressure & Standard Deviation of Users") +
  theme(
    axis.text = element_text(size = 16),
    legend.key = element_rect(fill = "359"),
    legend.background = element_rect(fill = "white"),
    legend.position = c(0.12, 0.90),
    panel.grid.major = element_line(colour = "grey40"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white")
  )

#Corelation Matrix
col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white",
                           "cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
                           "#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))
col3 <- colorRampPalette(c("red", "white", "blue"))
col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F",
                           "cyan", "#007FFF", "blue","#00007F"))
wb <- c("white","black")

d2<-cor(featext)
#cor_mat_plot <- corrplot(d2,order="hclust", addrect=2, col=col4(10))


#Orientation plots of a user
#Function call to get the various users pattern in landscape and portrait
#The function needs 2 input values:-
#   1. User id - values range from 0 to 40
#   2. Phone orientation - values can be 1 or 2

orientation <- function(userid,orient)
{
  #subset user with their respective ID
  user <- dataset[dataset$uid == userid,]  
  qplot(data = user[(user$ph_ori == orient) ,], x = x_cord,
        main = toupper(orientname(orient)), 
        y= y_cord)
}

orientname <- function(orient){
  val1 <- NULL
  
  if(orient==1)
  {
    val1 = "portrait"
  }
  else
  {
    val1 = "landscape"
  }
  val1 = (paste(val1,"orientation plot"))
  return (val1)
}

#Subset dataset with phone id 1
ph1 <- dataset[dataset$p_id == 1,]


#Plot Pressure of users for a random of 100 training sets
ph1_s <- ph1[sample(nrow(ph1),500),]

press_points <- plot_ly(ph1_s, x = x_cord , y = y_cord,main = "Pressure dots of users for a random of 100 training sets",
        text=paste("Pressure: ",pressure, "Area: ", area),
        mode="markers", color = uid, size=uid )



#Plot traces of accessing wikipedia article & image comparison game 
#Valid users for phone_id=1 are 36,5,39,16,18,12
user_doc_traces <- function(userid)
{
  
  set1 <- ph1[ph1$uid== userid,]
  
  for (i in 1:length(set1$docid))
  {
    if(set1$docid[i]==0)
      set1$doc.name[i]="Wikipedia Artice 1"
    else if(set1$docid[i]==1)
      set1$doc.name[i]="Wikipedia Article 2"
    else if(set1$docid[i]==2)
      set1$doc.name[i]="Wikipedia Article 3"
    else if(set1$docid[i]==3)
      set1$doc.name[i]="Image Comparion Game 1"
    else if(set1$docid[i]==4)
      set1$doc.name[i]="Image Comparion Game 2"
    else if(set1$docid[i]==5)
      set1$doc.name[i]="Wikipedia Article 4"
    else
      set1$doc.name[i]="Image Comparion Game 3"
  }
  
  p_doc <- ggplot(data = set1, aes(x = x_cord, y = y_cord)) +
    ggtitle((paste("Traces of User ID", userid,
                   "in various applications"))) +
    geom_point(aes(text = paste( "Area :", area)), size = 0.5) +
    geom_smooth(aes(color = doc.name))	 + 
    facet_wrap(~ doc.name)
  
  ggplotly(p_doc)
  
}
#user_doc_traces(18)

#Plot Touch Traces of users in Nexus 1-Experimenter E
#Roll the cursor over the graph to check pressure points
#Valid users for phone_id=1 are 36,5,39,16,18,12

user_finger_trace <- function(userid)
{
  set1 <- ph1[ph1$uid==userid,]
  
  
  for (i in 1:length(set1$action))
  {
    if(set1$action[i]==0)
      set1$action.name[i]="Touch Down Traces"
    else if(set1$action[i]==1)
      set1$action.name[i]="Touch Up Traces"
    else
      set1$action.name[i]="Finger Movement Traces"
  }
  
  p_set1 <- ggplot(data = set1, aes(x = x_cord, y = y_cord)) +
    ggtitle((paste("Touch Traces of User ID ",userid,
                   "in Nexus 1-Experimenter E"))) +
    geom_point(aes(text = paste("Pressure :", pressure)), size = 0.5) +
    geom_smooth(aes(color = action.name))	 + 
    facet_wrap(~ action.name)
  
  ggplotly(p_set1)
  
}

#user_finger_trace(36)
