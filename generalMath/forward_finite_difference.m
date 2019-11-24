function diff_A=forward_finite_difference(initial_A,perturbated_A, perturbation)
diff_A = (perturbated_A - initial_A) / perturbation;
end