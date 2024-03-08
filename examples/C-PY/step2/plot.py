import numpy as np
import matplotlib.pyplot as plt

data = []
with open("input/enc/res.txt", "r") as file:
	for line in file:
		n = line.strip()
		data.append(float(n))

bins = np.arange(1,11)
plt.hist(data, weights=np.ones(len(data)) / len(data))
plt.xticks(range(1,11))
plt.ylabel("Percentage")
plt.xlabel("Passwords' grade")
plt.title("Passwords' strength")

plt.savefig('results/prova.png')