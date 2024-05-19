%% Part A
df = Ftrue;
df_true = Ftrue - mean(Ftrue, 1);
cov_mat_true = cov(df_true);
[evec, eval] = eig(cov_mat_true);
lambda = diag(eval);
[lambda_sorted, idx] = sort(diag(eval), 'descend');
evec_sorted = evec(:, idx);
dest = 6;

cnstrnt_mat_true = evec_sorted(:, 18:23)';

% finding choices for dependend and independent variables
p = length(lambda_sorted);
condition_number = [];
dep_variables = [];

for i = 1:(p-5)
    for j = (i+1):(p-4)
        for k = (j+1):(p-3)
            for m = (k+1):(p-2)
                for n = (m+1):(p-1)
                    for o = (n+1):p
                        dep_var = cnstrnt_mat_true(:, [i j k m n o]);
                        dep_variables = [dep_variables; [i j k m n o]];
                        condition_number = [condition_number; cond(dep_var)];
                    end
                end
            end
        end
    end
end

cond_result_true = table(dep_variables, condition_number);
cond_result_true = sortrows(cond_result_true, "condition_number");

fprintf('\nGOOD choices for dependent variables:\n')
disp(cond_result_true(1:54, :)) % there are more good chooices but printing out all those having same cond number

%% Part B
good_choices = [5, 7, 16, 17, 19, 23];

all_columns = 1:size(cnstrnt_mat_true, 2);
indep_choices = setdiff(all_columns, good_choices);
indep_true = cnstrnt_mat_true(:, indep_choices);
dep_true = cnstrnt_mat_true(:, good_choices);

Reg_mat_true = -1 .* (inv(dep_true) * indep_true); % true regression matrix

%% Part C

df_meas = Fmeas - mean(Ftrue, 1);
cov_mat_meas = cov(df_meas);
[evec_meas, eval_meas] = eig(cov_mat_meas);
lambda_meas = diag(eval_meas);
[lambda_sorted_meas, idx] = sort(diag(eval_meas), 'descend');
evec_sorted_meas = evec_meas(:, idx);


no_of_constraints = [];
status = [];
test_statistic = [];
test_criteria = [];
degree_of_freedom = [];

p = length(lambda_sorted_meas);
r = p - 1;
N = size(Fmeas);
N = N(1);

while r > 1
    j = p - r;
    Q = testStat(lambda_sorted_meas, r, j, N); % test statistic
    df = ((r*(r+1))/2) - 1; % degree of freedom
    c = chi2inv(0.95, df); % test criteria
    d = r; % no of constraints

    no_of_constraints = [no_of_constraints; d];
    test_statistic = [test_statistic; Q];
    test_criteria = [test_criteria; c];
    degree_of_freedom = [degree_of_freedom; df];

    if Q > c
        status = [status; "Rejected"];
    end
    if Q <= c
        status = [status; "Not Rejected"];
    end
    
    r = r - 1;
end

fprintf('\nTraditional Hypothesis Testing results:\n\n')
test_results_1 = table(no_of_constraints, degree_of_freedom, test_statistic, test_criteria, status);

dest_meas = 6; % no of contraints at last Not Rejected

cnstrnt_mat_meas = evec_sorted_meas(:, 18:23)';

% Error Variance
A = cnstrnt_mat_meas;
Zs = df_meas;
Zs_hat = Zs*(A')*A; % denoised data
err_Zs = Zs - Zs_hat; % error in data
% variance of error in measurements
var_err_data = var(err_Zs);

% finding choices for dependend and independent variables
p = length(lambda_sorted_meas);
condition_numbers_meas = [];
dep_variables_combinations_meas = [];

for i = 1:(p-5)
    for j = (i+1):(p-4) 
        for k = (j+1):(p-3)  
            for m = (k+1):(p-2)  
                for n = (m+1):(p-1)  
                    for o = (n+1):p  
                        dep_vars = cnstrnt_mat_meas(:, [i j k m n o]);  
                        dep_variables_combinations_meas = [dep_variables_combinations_meas; [i j k m n o]];  
                        condition_numbers_meas = [condition_numbers_meas; cond(dep_vars)];  
                    end
                end
            end
        end
    end
end

cond_result_meas = table(dep_variables_combinations_meas, condition_numbers_meas);
cond_result_meas = sortrows(cond_result_meas, "condition_numbers_meas");

%% Part D
good_choices_meas = [5, 7,	16,	17,	19,	23];

all_columns_meas = 1:size(cnstrnt_mat_meas, 2);
indep_choices_meas = setdiff(all_columns_meas, good_choices_meas);
indep_true_meas = cnstrnt_mat_meas(:, indep_choices_meas);
dep_true_meas = cnstrnt_mat_meas(:, good_choices_meas);

Reg_mat_meas = -1 .* (inv(dep_true_meas) * indep_true_meas); % estimated regression matrix

max_abs_diff = max(abs(Reg_mat_meas - Reg_mat_true), [], "all"); % maximum absolute difference


%% Used Functions
function Q = testStat(eigval, r, j, N)
    lamda_bar = sum(eigval((j+1):(j+r)), 'all') / r;
    sum_log_lamda = sum(log(eigval((j+1):(j+r))), 'all');
    Q = (r * (N-1) * log(lamda_bar)) - ((N-1) * sum_log_lamda);
end

