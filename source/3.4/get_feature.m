function v = get_feature(img, L)
    v = zeros(1, 2^(3*L));
    for i = 1:size(img, 1)
        v = v + histcounts(img(i, :), 0:2^(3 * L))/numel(img);
    end
end