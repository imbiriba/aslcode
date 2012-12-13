function doc_tree = card_parse(cfiles)
% function doc_tree = card_parse(cfiles)
%
% Will parse the cell array list of card files and generate a documentation tree structure.
%
%
% Breno Imbiriba - 2012.12.12


  base_str = doc_tree;

  % Declare ccard class variables
  card0  = ccard;
  card   = ccard;
keyboard
  % Read all cfiles and put the data into the 'card' ccard class
  icard=0;
  for ifile=1:numel(cfiles)
    card0 = read_cards_l(cfiles{ifile});
    if(~isstruct(card0))
      continue
    end
    icard=icard+1;
    card(icard) = card0;
  end
 
 keyboard 
  % Construct the documentation tree - who calls who
  %doc_tree = make_doc_tree_l(card);


  % Make the LaTeX output
  %make_latex_doc_l(card, doc_tree);

end

function card0 = read_cards_l(fname)

  fh=fopen(fname,'r');


end


