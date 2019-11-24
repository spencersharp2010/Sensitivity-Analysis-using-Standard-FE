function diff_A=backward_finite_difference(initial_A,perturbated_A, perturbation)
diff_A = (initial_A-perturbated_A) / perturbation;
end