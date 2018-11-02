function examClassifier(X, Y, w, b)
%EXAMCLASSIFIER 此处显示有关此函数的摘要
%   此处显示详细说明
scores = X'*w + b;
labels = Y';
learned_rate( scores, labels );

non_face_scores = scores( labels < 0);
face_scores     = scores( labels > 0);
plot(sort(face_scores), 'g'); hold on
plot(sort(non_face_scores),'r');
plot([0 size(non_face_scores,1)], [0 0], 'b');
hold off;
legend('face','non-face');
end

