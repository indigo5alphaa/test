
# seperate section --------------------------------------------------------


## Use #### #### or ctrl + shift + r to separate sections within scripts


# packages ---------------------------------------------------------------

install.packages('remotes') # for installing packages from sources that aren't CRAN
library(remotes) # load the package

install_github("allisonhorst/palmerpenguins") #installing development version of dataset
library(palmerpenguins) # loading the package which contains dataset we will use


install.packages('tidyverse')
library(tidyverse) # loading tidyverse package for ggplot etc.


# session info ------------------------------------------------------------

sessionInfo()


# create data ---------------------------------------------------------------

data(penguins, package = "palmerpenguins")

# where to put in the github folder
write.csv(penguins_raw, "raw_data/penguins_raw.csv", row.names = FALSE)

write.csv(penguins,"raw_data/penguins.csv",row.names = FALSE)


# load data ---------------------------------------------------------------

pen.data <- read.csv("raw_data/penguins.csv")

str(pen.data) # look at data types (e.g., factor, character)
colnames(pen.data) # look at the column names

# check for bullshit
head(pen.data) # first few rows of the start of the data
tail(pen.data) # last few rows at the end

# [row, column] and we want columns 3:6 and 8 which are the numeric variables
?pairs # will give you information about the function

pairs(pen.data[,c(3:6,8)]) # pairwise correlation plot of numeric columns

hist(pen.data$body_mass_g)  # make a histogram    

boxplot(pen.data$body_mass_g ~ pen.data$species) # boxplot of body mass x species


# save figures as pdf -----------------------------------------------------

pdf("output_data/wt_by_spp.pdf",
    width = 7,
    height = 5) # open a graphics device (everything you print to the screen while this is open will be saved to the file name that you give here), there are analogous functions for png and other image types


boxplot(pen.data$body_mass_g ~ pen.data$species,
        xlab="Species", ylab="Body Mass (g)") # print the boxplot to the pdf file


dev.off() #close the graphics device (very important to run this line or the pdf won’t save and will continue to add new plots that you run afterwards)


# ggplot figure -----------------------------------------------------------

library(tidyverse)

pen_fig <- pen.data %>% # calling on the data
  drop_na() %>%  # dropping "NAs" from the plot
  ggplot(aes(y = body_mass_g, x = sex, # aesthetic: y = body mass, x = sex
             colour = sex)) + # colour violin plots by sex
  facet_wrap(~species) + # each species will have it's own plot
  geom_violin(trim = FALSE, # violin plot, turn off trim the edges
              lwd = 1) + # make the lines thick
  theme_bw() + # black and white background theme
  theme(text = element_text(size = 12), # change the text size
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size=12),
        legend.position = "none") + # remove the legend
  labs(y = "Body Mass (g)", # specify labels on axes
       x = " ") +
  scale_colour_manual(values = c("black", "darkgrey"))

pen_fig

ggsave("output_data/pen_fig.jpeg", pen_fig, # save figure to output
       width = 7,
       height = 5)



