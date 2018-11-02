function learned_rate( scores, labels )

% correct = sign(scores .* labels);
% accuracy = 1 - sum(correct <= 0)/length(correct);
% fprintf('  accuracy:   %.5f\n', accuracy);

true_positives = (scores >= 0) & (labels >= 0);
tp = sum( true_positives ) / length( true_positives);
fprintf('  true  positive rate: %.5f\n', tp);

false_positives = (scores >= 0) & (labels < 0); %¼ÙÁ³
fp = sum( false_positives ) / length( false_positives);
fprintf('  false positive rate: %.5f\n', fp);

true_negatives = (scores < 0) & (labels < 0);
tn = sum( true_negatives ) / length( true_negatives);
fprintf('  true  negative rate: %.5f\n', tn);

false_negatives = (scores < 0) & (labels >= 0); %Î´Ì½²âµ½µÄÕæÁ³
fn = sum( false_negatives ) / length( false_negatives);
fprintf('  false negative rate: %.5f\n', fn);

rec = tp/(tp+fn); prec = tp/(tp+fp); accu = (tp+tn)/(fp+tp+tn+fn);
fprintf('  Accuracy is: %.5f\n', accu);
fprintf('  Precision is: %.5f\n', prec);
fprintf('  Recall rate is: %.5f\n', rec);
end