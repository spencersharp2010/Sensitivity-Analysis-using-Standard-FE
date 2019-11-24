function diff_A=central_finite_difference(forward_perturbated_A,backward_perturbated_A, perturbation)
diff_A = (forward_perturbated_A - backward_perturbated_A) / (2*perturbation);
end