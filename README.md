# AltMin and PJ-ADMM
Low Complexity Signal Detection Algorithms for Massive MIMO communications

In the main.m (line 11), you can specify the algorithm that you would like to run. By default the line is set to "Algorithm = 'alterMin';"
There are two algorithms, AltMin and Proximal Jacobian ADMM which are described in our two papers:
  [A Low-Complexity Detection Algorithm For Uplink Massive MIMO Systems Based on Alternating Minimization](https://ieeexplore.ieee.org/abstract/document/8642914)
  [A Proximal Jacobian ADMM Approach for Fast Massive MIMO Signal Detection in Low-Latency Communications](https://arxiv.org/abs/1903.00738)
  
When you choose any of the two algorithms and run the main file, the code will also run MMSE algorithm, and generate a figure that compares the performance of the algorithm with MMSE.

When you use our Algorithms, please cite our two papers:

@article{elgabli2019low,
  title={A Low-Complexity Detection Algorithm For Uplink Massive MIMO Systems Based on Alternating Minimization},
  author={Elgabli, Anis and Elghariani, Ali and Aggarwal, Vaneet and Bell, Mark R},
  journal={IEEE Wireless Communications Letters},
  year={2019},
  publisher={IEEE}
}

@article{elgabli2019proximal,
  title={A Proximal Jacobian ADMM Approach for Fast Massive MIMO Signal Detection in Low-Latency Communications},
  author={Elgabli, Anis and Elghariani, Ali and Aggarwal, Vaneet and Bell, Mark R and others},
  journal={arXiv preprint arXiv:1903.00738},
  year={2019}
}

