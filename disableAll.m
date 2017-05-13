function disableAll(h)

ch = get(h, 'Children');
for i=1:length(ch)
    if isprop(ch(i), 'Enable')
        set(ch(i), 'Enable', 'off');
    end
end

hh = guidata(h);
ch = get(hh.uipanel1, 'Children');
for i=1:length(ch)
    if isprop(ch(i), 'Enable')
        set(ch(i), 'Enable', 'off');
    end
end

ch = get(hh.uibuttongroup1, 'Children');
for i=1:length(ch)
    if isprop(ch(i), 'Enable')
        set(ch(i), 'Enable', 'off');
    end
end

ch = get(hh.uibuttongroup2, 'Children');
for i=1:length(ch)
    if isprop(ch(i), 'Enable')
        set(ch(i), 'Enable', 'off');
    end
end

